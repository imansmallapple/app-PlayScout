import router from '@ohos.router';
import { GameDataSource } from '../data/DataSource';
import { Game, GameDetails, ScreenShot } from '../model/game';
import promptAction from '@ohos.promptAction';

interface RouterParams {
  game_id: number
}

@Entry
@Component
struct GameDetail {
  @State httpCode: number = 0
  private game_id: number = 0
  @State gameDetail: GameDetails = new GameDetails()
  @State screenshots: ScreenShot[] = []
  scroller: Scroller = new Scroller()
  private swiperController: SwiperController = new SwiperController()
  @State selectedIndex: number = 0
  //@State isScaling: boolean = true;
  @State imgScale: number = 1;
  currentScale: number = 1;
  @State isSelected: boolean = false
  private intervalId: number | null = null; // 定时器 ID

  aboutToAppear(): void {
    const params: RouterParams = router.getParams() as RouterParams
    this.game_id = params.game_id

    const source = new GameDataSource()
    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code
      if (code === 200) {
        this.gameDetail = await source.GetGamesDetail(this.game_id)
        this.screenshots = this.gameDetail.screenshots

        // 开启自动切换定时器
        this.startAutoSwitch();
      } else {
        console.error('Failed to fetch data: HTTP Code', code);
      }
    })
  }

  // 定时器：每隔0.5秒切换到下一张图片
  private startAutoSwitch() {
    if (this.screenshots.length > 0) {
      this.intervalId = setInterval(() => {
        this.selectedIndex = (this.selectedIndex + 1) % this.screenshots.length;
      }, 5000); // 每隔 500 毫秒切换
    }
  }

  // 清理定时器
  onDestroy(): void {
    if (this.intervalId !== null) {
      clearInterval(this.intervalId);
    }
  }

  build() {
    Scroll() {
      Column() {

        // Image screenshot detail
        Row() {
          if (this.screenshots[0] !== undefined) {
            Image(`${this.screenshots[this.selectedIndex].image}`)
          }
        }

        // Small image list
        List({ scroller: this.scroller, initialIndex: this.selectedIndex }) {
          ForEach(this.screenshots, (item: ScreenShot, index: number) => {
            ListItem() {
              Column() {
                if (this.selectedIndex == index) {
                  Image(`${item.image}`)
                    .objectFit(ImageFit.Contain)
                    .borderWidth(2)
                    .borderColor('#6dd91d1d')
                } else {
                  Image(`${item.image}`)
                    .objectFit(ImageFit.Contain)
                    .onClick(() => {
                      this.selectedIndex = index
                    })
                }
              }
            }
            .width('31%')
            .margin(5)
          })
        }
        .listDirection(Axis.Horizontal)
        .cachedCount(3)
      }
    }
    .width('100%')
    .height('100%')
  }
}