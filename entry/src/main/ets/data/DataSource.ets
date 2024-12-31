import { Game, GameDetails, Min_System_Requirements, ScreenShot } from '../model/game'
import http from '@ohos.net.http'

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
const Game_By_Platform_URL: string = BASE_URL + `/games?platform=`

// Games by release date
const Game_By_ReleaseDate_URL: string = BASE_URL + `/games?sort-by=release-date`

//Games by category or tag
const Game_By_CategoryOrTag_URL: string = BASE_URL + `/games?category=`

//Sort games by release date, alphabetical or relevance
const Game_By_DateOrAlphabetOrRelevance_URL: string = BASE_URL + `/games?sort-by=${sortBy}`

//Return details from a specific game, need plus ${game_id}
const Get_Game_URL: string = BASE_URL + `/game?id=`

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

  // Get top 5 recent games
  async GetRecentGames(): Promise<Game[]> {
    // 返回一个 Promise 来确保异步请求的结果可以正确传递
    return new Promise<Game[]>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(Game_By_ReleaseDate_URL, (err, data) => {
        if (!err) {
          try {
            let responseData: Game[] = JSON.parse(data.result as string)
            let topFiveGames = responseData.slice(0, 5);
            resolve(topFiveGames); // 请求成功，返回数据
          } catch (error) {
            reject('Failed to parse response data'); // 捕获解析错误
          }
        } else {
          reject('Error: ' + err); // 请求失败，返回错误
        }
      });
    });
  }

  // Get all recent games
  async GetAllRecentGames(): Promise<Game[]> {
    // 返回一个 Promise 来确保异步请求的结果可以正确传递
    return new Promise<Game[]>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(Game_By_ReleaseDate_URL, (err, data) => {
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

  // sort all games by category or tag
  async SortGamesByPlatform(platform: string): Promise<Game[]> {
    // 返回一个 Promise 来确保异步请求的结果可以正确传递
    return new Promise<Game[]>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(Game_By_Platform_URL + `${platform}`, (err, data) => {
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

  // sort all games by category or tag
  async SortGamesByTag(tag: string): Promise<Game[]> {
    // 返回一个 Promise 来确保异步请求的结果可以正确传递
    return new Promise<Game[]>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(Game_By_CategoryOrTag_URL + `${tag}`, (err, data) => {
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

  // Get top 5 recent games
  async GetGamesDetail(game_id: number): Promise<GameDetails> {
    // 返回一个 Promise 来确保异步请求的结果可以正确传递
    return new Promise<GameDetails>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(`${Get_Game_URL}${game_id}`, (err, data) => {
        if (!err) {
          try {
            let responseData: GameDetails = JSON.parse(data.result as string)
            resolve(responseData);
          } catch (error) {
            reject('Failed to parse response data');
          }
        } else {
          reject('Error: ' + err);
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
      return response;
    } catch (error) {
      console.error('Error fetching HTTP code:', error);
      return -1;
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

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

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

  public clear() {
    this.dataArray = []
  }
}


export { GameDataSource, MyDataSource }