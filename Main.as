package  {
	import flash.display.Sprite;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import com.adobe.images.JPGEncoder;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class Main extends Sprite{
		private var camera:Camera = Camera.getCamera(); //An instance of the camera object, necesary to use the webcam
		private var video:Video = new Video(); //Used to display the live video from the webcam
		private var bmd:BitmapData = new BitmapData(1024,768);//Creates a new BitmapData with the parameters as size
		private var bmp:Bitmap; //This bitmap will hold the bitmap data, which is the captured data from the webcam
		private var fileReference:FileReference = new FileReference(); //A file reference instance used to access the save to disk function
		private var byteArray:ByteArray; //This byte array instance will hold the data created from the jpg encoder and use it to save the image
		private var jpg:JPGEncoder = new JPGEncoder(); //An instance of the jpg encoder class
		
		public function Main() {
			saveButton.visible = false;
			discardButton.visible = false;
			saveButton.addEventListener(MouseEvent.MOUSE_UP, saveImage);
			discardButton.addEventListener(MouseEvent.MOUSE_UP, discard);
			capture.addEventListener(MouseEvent.MOUSE_UP, captureImage);
			if(camera != null)
			{
			video.smoothing = true; //Removes pixelated image from the webcam video
			video.attachCamera(camera); //Adds the webcam input to the video object
			video.x = 140; //Video position
			video.y = 40;
			addChild(video); //Add video to stage
			}
			else
			{
				trace("No Camera Detected");
			}
		}
		private function captureImage(e:MouseEvent):void
		{
			bmd.draw(video);
			bmp = new Bitmap(bmd);
			bmp.x = 140;
			bmp.y = 40;
			addChild(bmp);
		
			capture.visible = false;
			saveButton.visible = true;
			discardButton.visible = true;
		}
		
		private function saveImage(e:MouseEvent):void
		{
			var jpgEncoder:JPGEncoder = new JPGEncoder(85);
			var jpgStream:ByteArray = jpgEncoder.encode(bmd);
			
						
			//set the request's header,method and data
			var header:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
			var loader:URLLoader = new URLLoader();
			//sends jpg bytes to saveJPG.php script
			var myRequest:URLRequest = new URLRequest("savepicture.php");
			myRequest.requestHeaders.push(header);
			myRequest.method = URLRequestMethod.POST;			
			myRequest.data = jpgStream;
			loader.load(myRequest);
			//fire complete event;
			loader.addEventListener(Event.COMPLETE,saved);
			function saved(e:Event)
			{
				//trace the image file name
				trace(loader.data);
			}
			
		}
		
		
		
		private function discard(e:MouseEvent):void
		{
			removeChild(bmp);
			saveButton.visible = false;
			discardButton.visible = false;
			capture.visible = true;
		}

	}
	
}
