
import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:notus/notus.dart';
import 'package:notustohtml/notustohtml.dart';
import 'package:quill_delta/quill_delta.dart';

void main() {
  final converter = NotusHtmlCodec();

//   final html2 = """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
// <html xmlns="http://www.w3.org/1999/xhtml">
// 	<head>
// 		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>
// 		</title>
// 		<style type="text/css">
// 			.cs4FC7BF42{text-align:left;margin:0pt 0pt 0pt 0pt;list-style-type:disc;color:#000000;background-color:transparent;font-family:Arial;font-size:12pt;font-weight:normal;font-style:normal}
// 			.cs9D249CCB{color:#000000;background-color:transparent;font-family:'Times New Roman';font-size:12pt;font-weight:normal;font-style:normal;}
// 			.cs72F7C9C5{color:#000000;background-color:transparent;font-family:'Times New Roman';font-size:12pt;font-weight:bold;font-style:normal;}
// 		</style>
// 	</head>
// 	<body>
// 		<ul style="margin-top:0;margin-bottom:0;">
// 			<li class="cs4FC7BF42"><span class="cs9D249CCB">Point</span></li><li class="cs4FC7BF42"><span class="cs9D249CCB">Point</span></li><li class="cs4FC7BF42"><span class="cs72F7C9C5">Tedt</span></li></ul>
// 	</body>
// </html>""";

  final html2 = """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>
		</title>
		<style type="text/css">
			.cs3A4479F6{color:#FF0000;text-align:left;text-indent:0pt;margin:0pt 0pt 12pt 0pt}
			.cs2E101AC8{background-color:transparent;font-family:'Times New Roman';font-size:12pt;font-weight:normal;font-style:normal;}
		</style>
	</head>
	<body>
		<p class="cs3A4479F6"><span class="cs2E101AC8">Test</span></p></body>
</html>
""";
  // Replace with the document you have take from the Zefyr editor
  var parsed = parse(html2);

  Element node = parsed.head.nodes.firstWhere((element) => element is Element && element.localName.contains("style")) as Element;
  var text = node.firstChild.text.replaceAll("\t", "");
  var result = text.split("\n").where((element) => element.isNotEmpty).toList();

  String newHtml = html2;
  result.forEach((element) {
    var indexOfBracket = element.indexOf('{');
    var styleName = element.startsWith(".") ? element.substring(1, indexOfBracket) : element.substring(0, indexOfBracket);
    var items = element.substring(indexOfBracket, element.length).replaceAll("{", "").replaceAll("}", "");

    print("$styleName: $items");
    newHtml = newHtml.replaceAll('class="$styleName"', 'style="$items"');
  });

  // print(newHtml);


  // print(firstStyle.span.text);
  final doc = NotusDocument.fromJson(
    [
      {
        "insert": "Hello World!",
        "attributes": {
          "color": "#FF0000",
          "size": 12
        },
      },
      {
        "insert": "\n",
      },
    ],
  );

  final html3 = """<body>
		<p style="text-align:left;text-indent:0pt;margin:0pt 0pt 12pt 0pt"><span style="color:#FF0000;background-color:transparent;font-family:'Times New Roman';font-size:12pt;font-weight:normal;font-style:normal;">Test</span></p></body>
""";
  String html = converter.encode(doc.toDelta());
  // print(html); // The HTML representation of the Notus document

  var indexOfBody = newHtml.indexOf("<body");
  var indexOfBodyEnd = newHtml.indexOf("</body>");
  var shortHtml = newHtml.substring(indexOfBody, indexOfBodyEnd) + "</body>";
  print(shortHtml);
  // Delta delta = converter.decode(html3); // Zefyr compatible Delta
  Delta deltaCheck = converter.decode(newHtml);
  print(deltaCheck);
  // NotusDocument document = NotusDocument.fromDelta(delta); // Notus document ready to be loaded into Zefyr
  // print(document);
}
