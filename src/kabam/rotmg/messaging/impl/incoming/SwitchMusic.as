package kabam.rotmg.messaging.impl.incoming {
import flash.utils.IDataInput;

public class SwitchMusic extends IncomingMessage {

    public var music_:String;

    public function SwitchMusic(id:uint, callback:Function) {
        super(id, callback);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.music_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("SWITCHMUSIC", "music_"));
    }


}
}