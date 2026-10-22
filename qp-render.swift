import Foundation
import CoreGraphics
import ImageIO

// Local macOS PDFKit conversion. No network, no drawing access, no external packages.
func render(_ directory: String) {
 let dir=URL(fileURLWithPath:directory,isDirectory:true)
 let marker=dir.appendingPathComponent("QP-JPG-status.txt")
 do {
    let files=try FileManager.default.contentsOfDirectory(at:dir,includingPropertiesForKeys:nil)
        .filter{$0.pathExtension.lowercased()=="pdf"}.sorted{$0.lastPathComponent<$1.lastPathComponent}
    guard !files.isEmpty else { throw NSError(domain:"QP",code:1,userInfo:[NSLocalizedDescriptionKey:"No PDF files"]) }
    for url in files {
        guard let doc=CGPDFDocument(url as CFURL), let page=doc.page(at:1),doc.numberOfPages==1 else {
            throw NSError(domain:"QP",code:2,userInfo:[NSLocalizedDescriptionKey:"Cannot read single-page PDF: \(url.lastPathComponent)"])
        }
        let rect=page.getBoxRect(.mediaBox)
        let scale:CGFloat=300/72
        let width=Int(ceil(rect.width*scale)),height=Int(ceil(rect.height*scale))
        guard width>0,height>0,width*height<200_000_000,
              let cg=CGContext(data:nil,width:width,height:height,bitsPerComponent:8,
                bytesPerRow:width*4,space:CGColorSpaceCreateDeviceRGB(),
                bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue) else {
            throw NSError(domain:"QP",code:3,userInfo:[NSLocalizedDescriptionKey:"Bitmap allocation failed"])
        }
        cg.setFillColor(CGColor(gray:1,alpha:1));cg.fill(CGRect(x:0,y:0,width:width,height:height))
        cg.scaleBy(x:scale,y:scale);cg.translateBy(x:-rect.minX,y:-rect.minY)
        cg.drawPDFPage(page)
        guard let image=cg.makeImage() else {
            throw NSError(domain:"QP",code:4,userInfo:[NSLocalizedDescriptionKey:"JPEG encoding failed"])
        }
        let dest=url.deletingPathExtension().appendingPathExtension("jpg")
        guard !FileManager.default.fileExists(atPath:dest.path) else {
            throw NSError(domain:"QP",code:5,userInfo:[NSLocalizedDescriptionKey:"Output already exists"])
        }
        guard let target=CGImageDestinationCreateWithURL(dest as CFURL,"public.jpeg" as CFString,1,nil) else {
            throw NSError(domain:"QP",code:6,userInfo:[NSLocalizedDescriptionKey:"JPEG destination unavailable"])
        }
        CGImageDestinationAddImage(target,image,[kCGImageDestinationLossyCompressionQuality:0.95,
            kCGImagePropertyDPIWidth:300,kCGImagePropertyDPIHeight:300] as CFDictionary)
        guard CGImageDestinationFinalize(target) else {
            throw NSError(domain:"QP",code:7,userInfo:[NSLocalizedDescriptionKey:"JPEG write failed"])
        }
    }
    try "OK \(files.count)\n".write(to:marker,atomically:true,encoding:.utf8)
 } catch {
    try? "ERROR \(error.localizedDescription)\n".write(to:marker,atomically:true,encoding:.utf8)
    exit(1)
 }
}

// The bundle is a local, headless one-shot worker. AutoCAD startapp launches it.
if CommandLine.arguments.count==2 && CommandLine.arguments[1].hasPrefix("/") {
 let arg=CommandLine.arguments[1]
 if arg.hasSuffix(".qpjob"),let directory=try? String(contentsOfFile:arg,encoding:.utf8) {
  render(directory.trimmingCharacters(in:.whitespacesAndNewlines))
 } else {render(arg)}
} else {
 let path=NSHomeDirectory()+"/Library/Caches/MayCAD/qp-current-job.txt"
 guard let attrs=try? FileManager.default.attributesOfItem(atPath:path),
       let date=attrs[.modificationDate] as? Date, Date().timeIntervalSince(date)<60,
       let dir=try? String(contentsOfFile:path,encoding:.utf8) else { exit(2) }
 render(dir.trimmingCharacters(in:.whitespacesAndNewlines))
}
