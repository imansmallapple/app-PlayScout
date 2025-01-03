import router from '@ohos.router';
import { GameDataSource } from '../data/DataSource';
import { Game, GameDetails, Min_System_Requirements, ScreenShot } from '../model/game';
import hilog from '@ohos.hilog';
import { HttpErrorComponent, LoadComponent } from '../Component/components';

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
  @State min_system_requirements: Min_System_Requirements = new Min_System_Requirements()
  scroller: Scroller = new Scroller()
  @State selectedIndex: number = 0
  @State imgScale: number = 1;
  currentScale: number = 1;
  @State isSelected: boolean = false
  private intervalId: number | null = null; // 定时器 ID
  @State isExpand: boolean = false
  @StorageLink('staredGames') staredGames: GameDetails[] = []
  @State isStared: boolean = false
  @State isLoading: boolean = false
  @State isHttpError: boolean = false
  private videoController: VideoController = new VideoController()
  @State isPause: boolean = false
  @State isFullScreen: boolean = false
  @State isClickedVideo: boolean = false

  aboutToAppear(): void {
    this.isLoading = true;
    const params: RouterParams = router.getParams() as RouterParams;
    this.game_id = params.game_id;

    const source = new GameDataSource();

    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code;
      if (code === 200) {
        this.gameDetail = await source.GetGamesDetail(this.game_id);
        this.screenshots = this.gameDetail.screenshots;
        this.min_system_requirements = this.gameDetail.minimum_system_requirements;
        // 开启自动切换定时器
        this.startAutoSwitch();
        // 检查是否已收藏
        this.isStared = this.staredGames.some((item) => item.id === this.gameDetail.id);
        this.isLoading = false;
      } else {
        this.isHttpError = true;
        this.isLoading = false;
        console.error('Failed to fetch data: HTTP Code', code);
      }
    });
  }

  // 定时器：每隔0.5秒切换到下一张图片
  private startAutoSwitch() {
    if (this.screenshots.length > 0) {
      this.intervalId = setInterval(() => {
        this.selectedIndex = (this.selectedIndex + 1) % this.screenshots.length;
      }, 5000);
    }
  }

  onDestroy(): void {
    if (this.intervalId !== null) {
      clearInterval(this.intervalId);
    }
  }

  private toggleFullscreen() {
    this.isFullScreen = !this.isFullScreen;
    if (this.isFullScreen) {
      // 开启全屏模式
      this.videoController.requestFullscreen(true)
    } else {
      // 退出全屏模式
      this.videoController.requestFullscreen(false)
    }
  }

  build() {
    Scroll() {
      if (this.isHttpError) {
        HttpErrorComponent({
          text: 'Seems you don\'t have Internet'
        })
      } else {
        if (this.isLoading) {
          LoadComponent()
        } else {
          Column() {

            // Heading image
            Row() {
              // Game video
              Video({
                src: 'https://www.freetogame.com/g/' + this.game_id + '/videoplayback.webm',
                previewUri: this.gameDetail.thumbnail,
                controller: this.videoController,
              })
                .aspectRatio(1.81)
                .autoPlay(true)
                .muted(false)
                .controls(this.isClickedVideo ? true : false)
                .onClick(() => {
                  this.isClickedVideo = true
                  this.isPause = !this.isPause
                  this.isPause ? this.videoController.pause() : this.videoController.start()
                })
                .onFullscreenChange(() => {
                  this.toggleFullscreen()
                })
                .objectFit(ImageFit.Contain)

              //Game thumbnail
              // Image(`${this.gameDetail.thumbnail}`)
              //   .objectFit(ImageFit.Contain)
            }

            // Game basic information
            Column() {
              Row() {
                // Name
                Row({ space: 10 }) {
                  Text(`${this.gameDetail.title}`)
                    .fontSize(28)
                    .fontWeight(700)
                  Image(this.isStared === true ? $r('app.media.icon_stared') : $r('app.media.icon_not_stared'))
                    .width(20)
                    .objectFit(ImageFit.Auto)
                }
                .onClick(() => {
                  // Each game can only be stared once
                  this.isStared = !this.isStared
                  if (this.isStared) {
                    this.staredGames.push(this.gameDetail)
                  } else {
                    // Remove game from stared list using filter
                    this.staredGames = this.staredGames.filter((item) => item.id !== this.gameDetail.id);
                  }
                  // Test stared game list data
                  // this.staredGames.forEach((item) => {
                  //   hilog.info(23, 'stared games', `${item.title}`)
                  // })
                })
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)
              .margin({ left: 10, top: 5, bottom: 5 })

              Row({ space: 5 }) {
                Image($r('app.media.icon_click'))
                  .width(30)
                  .margin({ left: 10, top: 10 })
                Button('Visit site')
                  .type(ButtonType.Normal)
                  .borderRadius(10)
                  .width('80%')
                  .backgroundColor('#ff000000')
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/Browser'
                    , params: {
                        url: this.gameDetail.game_url
                      }
                    })
                  })
              }.width('100%')

              // Developer, Publisher & Release Date
              Column() {
                Row({ space: 10 }) {
                  Column() {
                    Row() {
                      Text('Developer')
                        .fontColor('#61000000')
                    }
                    .width(100)
                    .margin({ left: 10 })
                  }

                  Column() {
                    Text(`${this.gameDetail.title}`)
                  }
                }
                .width('100%')
                .justifyContent(FlexAlign.Start)
                .margin(5)

                // Publisher
                Row({ space: 10 }) {
                  Column() {
                    Row() {
                      Text('Publisher')
                        .fontColor('#61000000')
                    }
                    .width(100)
                    .margin({ left: 10 })
                  }

                  Column() {
                    Text(`${this.gameDetail.publisher}`)
                  }
                }
                .width('100%')
                .justifyContent(FlexAlign.Start)
                .margin(5)

                // Release date
                Row({ space: 10 }) {
                  Column() {
                    Row() {
                      Text('Release Date')
                        .fontColor('#61000000')
                    }
                    .width(100)
                    .margin({ left: 10 })
                  }

                  Column() {
                    Text(`${this.gameDetail.release_date}`)
                  }
                }
                .width('100%')
                .justifyContent(FlexAlign.Start)
                .margin(5)

                // Platform
                Row({ space: 10 }) {
                  Column() {
                    Row() {
                      Text('Platform')
                        .fontColor('#61000000')
                    }
                    .width(100)
                    .margin({ left: 10 })
                  }

                  Column() {
                    Row({ space: 10 }) {
                      Text(`${this.gameDetail.platform}`)
                        .fontColor('#ff1e3fc6')
                      Image(this.gameDetail.platform === "PC (Windows)" ? $r('app.media.icon_window') : $r('app.media.icon_browser'))
                        .width(20)
                    }
                    .onClick(() => {
                      router.pushUrl({
                        url: 'pages/SortByPlatformPage',
                        params: {
                          platform: this.gameDetail.platform
                        }
                      })
                    })
                  }
                }
                .width('100%')
                .justifyContent(FlexAlign.Start)
                .margin(5)

                // Genre
                Row({ space: 10 }) {
                  Column() {
                    Row() {
                      Text('Genre')
                        .fontColor('#61000000')
                    }
                    .width(100)
                    .margin({ left: 10 })
                  }

                  Column() {
                    Text(`${this.gameDetail.genre}`)
                      .fontColor('#ff1e3fc6')
                  }
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/SortByTagPage',
                      params: {
                        tag: this.gameDetail.genre
                      }
                    })
                  })
                }
                .width('100%')
                .justifyContent(FlexAlign.Start)
                .margin(5)
              }
              .margin({ bottom: 10 })

              // Description
              Row() {
                Column() {
                  if (this.isExpand) {
                    Text(this.gameDetail.description)
                      .width('100%')
                  } else {
                    Text(this.gameDetail.description)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .width('100%')
                      .maxLines(10)
                  }
                  Text(this.isExpand ? 'Contract' : 'Expand')
                    .width('100%')
                    .fontColor('#ff1e3fc6')
                }
                .onClick(() => {
                  this.isExpand = !this.isExpand
                })
                .margin({ bottom: 20 })
              }
              .width('100%')
              .margin({ left: 5 })
              .justifyContent(FlexAlign.Start)
            }

            // Image screenshot detail
            Row() {
              if (this.screenshots[0] !== undefined) {
                Image(`${this.screenshots[this.selectedIndex].image}`)
                  .margin(5)
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
            .margin({ bottom: 20 })

            // System minimum requirements
            Column({ space: 5 }) {
              Row() {
                // title
                Text('System Requirements')
                  .fontSize(20)
                  .fontWeight(500)
              }
              .width('100%')

              // os
              Row({ space: 10 }) {
                Column() {
                  Row() {
                    Text('Operating System')
                      .fontColor('#61000000')
                  }
                  .width(75)
                  .margin({ left: 10 })
                }

                Column() {
                  Text(this.min_system_requirements?.os || 'N/A')
                    .width('75%')
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)
              .alignItems(VerticalAlign.Top)
              .margin(5)

              // Processor
              Row({ space: 10 }) {
                Column() {
                  Row() {
                    Text('Processor')
                      .fontColor('#61000000')
                  }
                  .width(75)
                  .margin({ left: 10 })
                }

                Column() {
                  Text(this.min_system_requirements?.processor || 'N/A')
                    .width('75%')
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)
              .alignItems(VerticalAlign.Top)
              .margin(5)

              // Graphics
              Row({ space: 10 }) {
                Column() {
                  Row() {
                    Text('Graphics')
                      .fontColor('#61000000')
                  }
                  .width(75)
                  .margin({ left: 10 })
                }

                Column() {
                  Text(this.min_system_requirements?.graphics || 'N/A')
                    .width('75%')
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)
              .alignItems(VerticalAlign.Top)
              .margin(5)

              // Storage
              Row({ space: 10 }) {
                Column() {
                  Row() {
                    Text('Storage')
                      .fontColor('#61000000')
                  }
                  .width(75)
                  .margin({ left: 10 })
                }

                Column() {
                  Text(this.min_system_requirements?.storage || 'N/A')
                    .width('75%')
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)
              .alignItems(VerticalAlign.Top)
              .margin(5)

            }
          }
        }
      }
    }
    .width('100%')
    .height('100%')
    .align(this.isLoading ? Alignment.Center : Alignment.Top)
  }
}