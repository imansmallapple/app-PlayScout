import router from '@ohos.router';
import { registerAllFonts } from '../font/registerFonts';

@Entry
@Component
struct Splash {
  @State flag: boolean = false;

  aboutToAppear(): void {
    registerAllFonts()
  }

  onPageShow(): void {
    animateTo({
      duration: 2000,
      onFinish:()=>{
        //when the animation finish go the main page
        setTimeout(()=>{
          router.replaceUrl({url: 'pages/Index'})
        }, 200)
      }
    }, () => {
      this.flag = true
    })
  }
  build() {
    Row() {
      Column() {
        Row() {
          Text('PLAY')
            .titleTextStyle('#FFFFFF')

          Text('ES')
            .titleTextStyle('#A65EEA')

          Text('COUT')
            .titleTextStyle('#FFFFFF')
        }
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
      .backgroundImage($r('app.media.playstore_home'))
      .backgroundImageSize(ImageSize.Cover)
    }
  }
}

@Extend(Text)
function titleTextStyle(fontColor: string | ResourceColor) {
  .fontSize(65)
  .fontWeight(FontWeight.Bolder)
  .fontColor(fontColor)
  .fontFamily('Teko')
}
