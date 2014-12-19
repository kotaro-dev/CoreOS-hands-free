CoreOS-hands-free
=================

I want to autoinstall like preseed(in Ubuntu), in CoreOS. using iso file.

###説明

[coreos_production_iso_image.iso] を使って coreos のinstallを行う際に、  
ubuntu preseed のように 自動でinstall できないか？と思い試した結果です。  
(*local nat 環境で箱庭的にできたので、github経由で出来ないか試したのですが失敗しました。httpsvrは別途立てて利用して下さい)  

###仕組み

1. syslinux.cfg に cloud-config-url= を追加。  
  (boot時にloadされるfile。[kick-coreos-install.cfg])  

1. [kick-coreos-install.cfg] - OneShot のunits を作成。  
  ([kick_coreos_install.sh] を取得し、実行します。)  

1. [kick_coreos_install.sh] - coreos-install の実行。  
  [11_kick_coreos_install.sh] : dhcp base - 付与されたip をbase にhostname を作成  
  [21_kick_coreos_install.sh] : static ip - shell べた書きの固定IP で環境構築  
  [kick_coreos_install.sh] - static_flg=0 (0: static / 1: dhcp)  
  
  [12_cloud-config.yml][22_cloud-config-staticip.yml] : coreos-install に読み込ませるconfig.   
  
  cloud-config.yml をloadして coreos-install を実施しています。  
  ([eject]と[reboot]も実施しています。)  
  
  [autologin.sh] : [22_cloud-config-staticip.yml] で units 処理でkick しています。  

しばらく経つと、再起動されて、[cloud-config.yml] に設定されている user でログインできます。

###所感

- coreos-install の処理がバックスレッドなので、表面上 正常に動作しているかわかりません。  
  おおよそ 30s ~ 60s程で reboot が始まりました。(ネットワーク環境次第と思います。)  
  ログは sudo journalctl -r  で確認しました。

- [12_cloud-config.yml] ：とりあえず、hostname と user setting のみです。  
  [22_cloud-config-staticip.yml] ： static ip 設定用です。  
  CoreOS のdocuments に従って記述しています。  
  nat + hostonly で環境構築した際に、DNS nameserver が host os の adapter の情報を  
  guest os のresolv.conf に書き込んでしまい、install 後の vbox の起動時に wait がかかってしまいました。  
  対策として、hosts を作成する 処理も追加しています。  
  SSH 接続の処理も wait が同様の理由で、wait がかかってしまったので、  
  sshd_config に UseDNS=no を追記しています。  

- iso file の解凍・再作成 の手順は[iso/Howtomake_iso.txt] に簡単に記載しておきました。

- 本当は、cloud-config で bootcmd か runcmd が利用できるとSimpleで良いのにと思っています。

多少なり、参考になる方がいればうれしいです。  
何度かCoreOSをinstallしている内に、preseed っぽいことが出来ないか気になって試してみました。  

###その他

- [kick_coreos_install.sh] enp0s8 を eth1 に変更。  
  (virtualbox の adaptor-type を 82540EM から virtio-net に変更)
