#install.packages("rvest")
#install.packages("dplyr")
library(rvest)
library(XML)
library(dplyr)
library(stringi)
artist = vector()
artist[1] = "CHVRCHES"
artist[2] = "Fall-Out-Boy"
artist[3] = "Green-Day"
artist[4] = "Dream-Theater"
artist[5] = "Imagine-Dragons"
artist[6] = "FKA-twigs"
artist[7] = "Hozier"
artist[8] = "Joywave"
artist[9] = "Tame-Impala"
#Done to this

#TODO

artist[10] = "부활" #한글 되는지 테스트 안되네.......
artist[11] = "Sigur-Ros" #아이슬란드어에 대한 인코딩문제 해결 필요 #이건 가상머신에서 돌리는 걸로...(locale문제)
artist[12] = "Eminem"

#이건 시작 순서에 따라 가변할 수 있음
#k는 artist 어레이 내에서 긁어올 artist 설정
for(k in 10:length(artist)) {
  #이건 작업 디렉토리 설정 이거 변경하면 해당 디렉토리 하에 아티스트 이름대로 폴더 생성
  setwd("D:/대학/작업/song_recommend")
  #이게 아티스트 이름대로 폴더 생성
  dir.create(artist[k])
  #작업 디렉토리를 아티스트 이름 폴더 내로 이동
  setwd(paste("D:/대학/작업/song_recommend","/",artist[k],sep=""))
  print(paste("Current Artist:",artist[k]))
  #에러 나면 i 페이지 수 수정....
  #musixmatch에선 아티스트 페이지에서 음악을 출력
  #단 load-more등으로 10개~15개씩밖에 출력하지 않으므로 1~10000번 반복
  #도중에 더 이상 출력할 음악이 없을 경우 break
  for(i in 1:10000) {
    #page에 아티스트의 음악 리스트의 html session을 저장 이 때 10개~15개씩 출력하는 페이지를 의미
    page = html_session(paste("https://www.musixmatch.com/artist/",artist[k],"/",i,sep=""))
    #page의 html session에서 .title span이 노래제목을 나타냄 이를 songname에 저장
    songname = html_text(html_nodes(page, ".title span"));songname = songname[songname != ""]
    #song에는 각 노래제목들의 하이퍼링크를 저장
    song = html_nodes(page, ".title") %>% html_attr("href")
    #봇임을 들키지 않기 위해 10초동안 휴식
    Sys.sleep(10)
    #더 이상 노래가 없을 경우 break
    if(length(song) == 0) break
    #페이지 내 곡들 중 에러난 경우 j 수정... // song의 길이만큼 반복
    for(j in 1:length(song)) {
      #lyric에 우선 song에 저장된 하이퍼링크로 탔을 경우의 html을 읽어옴
      lyric = read_html(paste("https://www.musixmatch.com",song[j],sep=""))
      #그리고 lyric에 저장된 html에서 가사부분인 #lyrics-html의 text를 읽어와 다시 lyric에 저장
      lyric = html_text(html_nodes(lyric, "#lyrics-html"))
      #이건 (노래 제목).txt 에 가사를 line breaking 제외하고 줄글로 쭉 저장 (현재 작업 디렉토리에 저장됨)
      write(gsub("\n"," ",lyric), file(gsub("\\*","-",gsub(":","-",gsub("\\?","",gsub("\u0080","-",gsub("\xe2","-",gsub("\"","-",paste(gsub("\\.","-",gsub("/","-",songname[j])),".txt",sep=""))))))),"wt"))
      #현재 쓰고 있는 노래제목 출력
      print(songname[j])
      #봇임을 들키지 않기 위해 10초 휴식
      Sys.sleep(10)
    }
  }
}

