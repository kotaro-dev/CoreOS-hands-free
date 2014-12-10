CoreOS-hands-free
=================

I want to autoinstall like preseed(in Ubuntu), in CoreOS. using iso file.

###説明

[coreos_production_iso_image.iso] を使って coreos のinstallを行う際に、  
ubuntu preseed のように 自動でinstall できないか？と思い試した結果です。  
(*local nat 環境で箱庭的にできたので、github経由で出来ないか試したのですが失敗しました。詳しく追いかけていません。)  

###仕組み

1. syslinux.cfg に cloud-config-url= を追加。  
  (boot時にloadされるfile。[kick-coreos-install.cfg])  

1. [kick-coreos-install.cfg] - OneShot のunits を作成。  
  ([kick_coreos_install.sh] を取得し、実行します。)  

1. [kick_coreos_install.sh] - coreos-install の実行。  
  [cloud-config.yml] : coreos-install に読み込ませるconfig.  
  cloud-config.yml をloadして coreos-install を実施しています。  
  ([eject]と[reboot]も実施しています。)  

しばらく経つと、再起動されて、[cloud-config.yml] に設定されている user でログインできます。

###所感

- coreos-install の処理がバックスレッドなので、表面上 正常に動作しているかわかりません。  
  おおよそ 30秒 程で reboot が始まりました。(ネットワーク環境次第と思います。)  
  ログは sudo journalctl  で確認しました。

- [cloud-config.yml] ：とりあえず、hostname と user setting のみです。  

- iso file の解凍・再作成 の手順は[iso/Howtomake_iso.txt] に簡単に記載しておきました。

- 本当は、cloud-config で bootcmd か runcmd が利用できるとSimpleで良いのにと思っています。

正直、参考になる方がいる気がしないのですが、  
何度かCoreOSをinstallしている内に、preseed っぽいことが出来ないか気になって試してみました。

###追加

- [kick_coreos_install.sh] にguest os の ip を取得して cloud-config の hostname を変更する処理を追加。  
  (本当は、http svr 側でcloud-config 管理用のプログラムを書くべきと思う。)

- [kick_coreos_install.sh] enp0s8 を eth1 に変更。  
  (virtualbox の adaptor-type を 82540EM から virtio-net に変更)
