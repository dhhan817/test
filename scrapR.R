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

artist[10] = "��Ȱ" #�ѱ� �Ǵ��� �׽�Ʈ �ȵǳ�.......
artist[11] = "Sigur-Ros" #���̽����� ���� ���ڵ����� �ذ� �ʿ� #�̰� ����ӽſ��� ������ �ɷ�...(locale����)
artist[12] = "Eminem"

#�̰� ���� ������ ���� ������ �� ����
#k�� artist ��� ������ �ܾ�� artist ����
for(k in 10:length(artist)) {
  #�̰� �۾� ���丮 ���� �̰� �����ϸ� �ش� ���丮 �Ͽ� ��Ƽ��Ʈ �̸���� ���� ����
  setwd("D:/����/�۾�/song_recommend")
  #�̰� ��Ƽ��Ʈ �̸���� ���� ����
  dir.create(artist[k])
  #�۾� ���丮�� ��Ƽ��Ʈ �̸� ���� ���� �̵�
  setwd(paste("D:/����/�۾�/song_recommend","/",artist[k],sep=""))
  print(paste("Current Artist:",artist[k]))
  #���� ���� i ������ �� ����....
  #musixmatch���� ��Ƽ��Ʈ ���������� ������ ���
  #�� load-more������ 10��~15�����ۿ� ������� �����Ƿ� 1~10000�� �ݺ�
  #���߿� �� �̻� ����� ������ ���� ��� break
  for(i in 1:10000) {
    #page�� ��Ƽ��Ʈ�� ���� ����Ʈ�� html session�� ���� �� �� 10��~15���� ����ϴ� �������� �ǹ�
    page = html_session(paste("https://www.musixmatch.com/artist/",artist[k],"/",i,sep=""))
    #page�� html session���� .title span�� �뷡������ ��Ÿ�� �̸� songname�� ����
    songname = html_text(html_nodes(page, ".title span"));songname = songname[songname != ""]
    #song���� �� �뷡������� �����۸�ũ�� ����
    song = html_nodes(page, ".title") %>% html_attr("href")
    #������ ��Ű�� �ʱ� ���� 10�ʵ��� �޽�
    Sys.sleep(10)
    #�� �̻� �뷡�� ���� ��� break
    if(length(song) == 0) break
    #������ �� ��� �� ������ ��� j ����... // song�� ���̸�ŭ �ݺ�
    for(j in 1:length(song)) {
      #lyric�� �켱 song�� ����� �����۸�ũ�� ���� ����� html�� �о��
      lyric = read_html(paste("https://www.musixmatch.com",song[j],sep=""))
      #�׸��� lyric�� ����� html���� ����κ��� #lyrics-html�� text�� �о�� �ٽ� lyric�� ����
      lyric = html_text(html_nodes(lyric, "#lyrics-html"))
      #�̰� (�뷡 ����).txt �� ���縦 line breaking �����ϰ� �ٱ۷� �� ���� (���� �۾� ���丮�� �����)
      write(gsub("\n"," ",lyric), file(gsub("\\*","-",gsub(":","-",gsub("\\?","",gsub("\u0080","-",gsub("\xe2","-",gsub("\"","-",paste(gsub("\\.","-",gsub("/","-",songname[j])),".txt",sep=""))))))),"wt"))
      #���� ���� �ִ� �뷡���� ���
      print(songname[j])
      #������ ��Ű�� �ʱ� ���� 10�� �޽�
      Sys.sleep(10)
    }
  }
}
