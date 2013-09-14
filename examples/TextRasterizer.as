package {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.Font;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.engine.CFFHinting;
import flash.text.engine.ElementFormat;
import flash.text.engine.FontDescription;
import flash.text.engine.FontLookup;
import flash.text.engine.FontPosture;
import flash.text.engine.FontWeight;
import flash.text.engine.Kerning;
import flash.text.engine.RenderingMode;
import flash.text.engine.TextBlock;
import flash.text.engine.TextElement;
import flash.text.engine.TextLine;
import flash.text.engine.TextRotation;
import flash.text.engine.TypographicCase;

public class TextRasterizer extends Sprite {
    [Embed(source='/Arimo-Regular.ttf', fontName="Arimo", embedAsCFF="true")]
    private static const FontClass:Class;
    [Embed(source='/Arimo-Regular.ttf', fontName="Arimo2", embedAsCFF="false")]
    private static const FontClass2:Class;
    private var _font:Font;
    private var _description:FontDescription;
    private var _format:ElementFormat;
    private var _block:TextBlock;
    private var _element:TextElement;
    private var _line:TextLine;
    private var _field:TextField;

    public function TextRasterizer() {
        _font = new FontClass() as Font;

        _description = new FontDescription();
        _description.fontName = _font.fontName;
        _description.fontWeight = FontWeight.NORMAL;
        _description.fontPosture = FontPosture.NORMAL;
        _description.fontLookup = FontLookup.EMBEDDED_CFF;
        _description.renderingMode = RenderingMode.CFF;
        _description.locked = true;

        _format = new ElementFormat(_description);
        _format.fontSize = 11;
        _format.kerning = Kerning.ON;
        _format.color = 0x000000;
        _format.alpha = 1;

        _element = new TextElement("Тест Привет Hello а айловьюлайкалов сомбэйбэ пипипипип", _format);

        _block = new TextBlock();
        _block.content = _element;

        _line = _block.createTextLine();
        _line.x = 10;
        _line.y = 30;

        addChild(_line);

        var _sp:Sprite = new Sprite();

        var b:Rectangle = _line.getBounds(_line);
        _sp.graphics.lineStyle(0, 0xff0000);
        //_sp.graphics.drawRect(b.x, b.y, b.width, b.height);
        _sp.x = _line.x;
        _sp.y = _line.y;
        addChild(_sp);

        Font.registerFont(FontClass2);

        _field = new TextField();
        _field.antiAliasType = AntiAliasType.ADVANCED;
        _field.gridFitType = GridFitType.SUBPIXEL;
        _field.sharpness = 0;
        _field.thickness = 0;
        _field.defaultTextFormat = new TextFormat(new FontClass2().fontName, _format.fontSize);
        _field.autoSize = TextFieldAutoSize.LEFT;
        _field.embedFonts = true;

        _field.text = _element.text;

        addChild(_field);
    }

    public function render(text:String):BitmapData {
        //_element.text = text;
        var result:BitmapData = new BitmapData(200, 200);
        result.draw(_line, null, null, null, null, true);

        return result;
    }

}
}
