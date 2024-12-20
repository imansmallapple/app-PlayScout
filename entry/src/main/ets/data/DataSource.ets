import { Game } from '../model/game'
import http from '@ohos.net.http'

const platform_name: string = 'pc'
const tag_name: string = 'shooter'
const sortBy: string = 'alphabetical'
const game_id: number = 452
const BASE_URL: string = "https://www.freetogame.com/api"
const multiple_tag: string = '3d.mmorpg.fantasy.pvp'

//Live games list
const GameList_URL: string = BASE_URL + '/games'
// [
// {
//         "id": 582,
//         "title": "Tarisland",
//         "thumbnail": "https://www.freetogame.com/g/582/thumbnail.jpg",
//         "short_description": "A cross-platform MMORPG developed by Level Infinite and Published by Tencent.",
//         "game_url": "https://www.freetogame.com/open/tarisland",
//         "genre": "MMORPG",
//         "platform": "PC (Windows)",
//         "publisher": "Tencent",
//         "developer": "Level Infinite",
//         "release_date": "2024-06-22",
//         "freetogame_profile_url": "https://www.freetogame.com/tarisland"
//     },
// ]
//Games by platform
const Game_By_Platform_URL: string = BASE_URL + `/games?platform=${platform_name}`

//Games by category or tag
const Game_By_CategoryOrTag_URL: string = BASE_URL + `/games?category=${tag_name}`

//Sort games by release date, alphabetical or relevance
const Game_By_DateOrAlphabetOrRelevance_URL: string = BASE_URL + `/games?sort-by=${sortBy}`

//Return details from a specific game
const Get_Game_URL: string = BASE_URL + `/game?id=${game_id}`

//personalized results
const Filter_Game_PersonalizedResult_URL: string = BASE_URL + `/filter?tag=${multiple_tag}`

class GameDataSource {
  public static GameList: Game[] = []

  constructor() {
  }

  async GetGameList(): Promise<Game[]> {
    // 返回一个 Promise 来确保异步请求的结果可以正确传递
    return new Promise<Game[]>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(GameList_URL, (err, data) => {
        if (!err) {
          try {
            let responseData: Game[] = JSON.parse(data.result as string)
            resolve(responseData); // 请求成功，返回数据
          } catch (error) {
            reject('Failed to parse response data'); // 捕获解析错误
          }
        } else {
          reject('Error: ' + err); // 请求失败，返回错误
        }
      });
    });
  }


  async fetchHttpCode(): Promise<number> {
    try {
      let httpRequest = http.createHttp();
      const response = await new Promise<number>((resolve, reject) => {
        httpRequest.request(GameList_URL, (err: Error, data: http.HttpResponse) => {
          if (!err) {
            resolve(data.responseCode);
          } else {
            reject(err);
          }
        });
      });
      return response; // 返回响应码
    } catch (error) {
      console.error('Error fetching HTTP code:', error);
      return -1; // 返回一个错误码
    }
  }
}

// Basic implementation of IDataSource to handle data listener
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: Game[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): Game {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

class MyDataSource extends BasicDataSource {
  private dataArray: Game[] = []

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): Game {
    return this.dataArray[index];
  }

  public addData(index: number, data: Game): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Game): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}


export { GameDataSource, MyDataSource }