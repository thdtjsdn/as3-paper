package {
import flash.text.Font;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

[Embed(source='/Arimo-Regular.ttf', fontName="Arimo", embedAsCFF="false")]
public class TestFont extends Font {
    public function TestFont() {
    }

    public function get format():TextFormat {
        Font.registerFont(TestFont);
        var result:TextFormat = new TextFormat(fontName, 11);
        result.align = TextFormatAlign.LEFT;
        return result;
    }
}
}
