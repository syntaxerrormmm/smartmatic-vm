# Materiale per le Voting Machine SmartMatic #

## Hardware ##

Le cosiddette Voting Machine sono, più correttamente, dei sistemi SmartMatic
VIU-800 (Voter Identification Unit).

Alcune informazioni sull'hardware:

* [Pagina della CPU su sito Intel](https://ark.intel.com/it/products/87383/Intel-Atom-x5-Z8300-Processor-2M-Cache-up-to-1_84-GHz)
* [FCC-ID: Materiale su VIU-800](https://fccid.io/2AGVK-VIU-800)
* [FCC-ID: Disassemblamento del VIU-800](https://fccid.io/2AGVK-VIU-800/Internal-Photos/Internal-photos-3266464.html);
* [Pagina del dispositivo su SmartMatic](http://www.smartmatic.com/voting/hardware/detail/viu-800/)
* [Pagina di Scuola Linux sulle Voting Machine](http://wiki.scuola.linux.it/doku.php?id=voting_machine_lombardia)

## Avvio e utilizzo della piattaforma EFI ##

Si può accedere direttamente alla configurazione del firmware della VM
utilizzando il tasto **Canc** di qualsiasi tastiera collegata via USB. Dopo
essere entrato nel firmware, il sistema è preimpostato con una password, che,
come riportato dal [Wiki Scuola Linux](http://wiki.scuola.linux.it/doku.php?id=voting_machine_lombardia) è `smart?ecp`.

In alternativa, come consigliato nella pagina sopra indicata, utilizzare il
menù di GRUB di Ubuntu-GNOME per accedere alle impostazioni del firmware.

Dall'interno delle impostazioni del firmware è pressoché impossibile scegliere
un dispositivo di boot differente da quelli già impostati; più semplice
utilizzare *EFI Shell* (qualche istruzione per l'utilizzo
[qui](https://downloadmirror.intel.com/16018/eng/EFI_Deployment.pdf)),
attendere il caricamento e puntare direttamente il file `.efi` contenuto nel
dispositivo da avviare.

Per esempio, se sto utilizzando una chiavetta USB (dispositivo esterno) per
effettuare il boot con un'altro sistema operativo, dovrò accedere al
dispositivo **blk1** e poi navigare fino al percorso dove esiste il file .efi:

    blk1:
    cd efi/boot
    grubx86.efi

Personalmente, ho eseguito almeno 4 sistemi operativi differenti (tutti
necessariamente con supporto EFI, l'avvio in modalità *legacy* **non** è supportato).

## Stato del supporto hardware per GNU/Linux ##

La piattaforma hardware ha alcuni grossi problemi anche su Linux.
Fondamentalmente, non sono supportati kernel precedenti alla versione 4.11;
anche versioni più aggiornate hanno necessità di essere configurate
manualmente con alcuni file/driver aggiuntivi per permettere al sistema di
utilizzarli correttamente.

In particolare, parliamo dei seguenti dispositivi:

* Scheda wireless: il chipset è Broadcom 43430 su bus SDIO, quindi non compare
  nell'output di `lspci` né `lsusb` (lo si può tuttavia vedere abbozzato
utilizzando `hwinfo`). Il driver è nel kernel almeno dalla versione 4.9 in su
(`brcmfmac`), ma necessita di alcuni [file
aggiuntivi](http://jwrdegoede.danny.cz/brcm-firmware/) che non vengono
distribuiti con i firmware né con i driver del kernel;
* Scheda audio: il chipset è Realtek 5645, il driver è nel kernel
  (`snd_soc_rt5645`) ma viene caricato assieme ad un altro e sia alsa chee
PulseAudio non sono in grado di utilizzarlo correttamente. &Egrave; necessario
caricare l'uno e blacklistare l'altro, quindi configurare correttamente il
dispositivo di output da PulseAudio (si veda parte sottostante).
* Stampante termica: ND
* Regolazione della luminosità: non funzionante con sistema nativo. Non sono
  stati effettuati altri test.

## Attivazione dell'audio ##

Il kernel `linux` in versione 4.15 ha internamente i driver per la scheda
audio integrata (il chipset è Realtek 5645 e il driver relativo è
`snd-soc-rt5645`), ma viene caricato contemporaneamente ad un altro driver
(che sfortunatamente ha la priorità) la quale scheda non è presente a sistema
e pertanto non funziona correttamente.

&Egrave; pertanto possibile correggere il funzionamento della scheda audio
effettuando le seguenti modifiche:

* Nel file `/etc/modules`, che indica quali driver del kernel caricare
  all'avvio, forzare il caricamento del driver `snd_soc_rt5645`:
```
echo 'snd_soc_rt5645' | sudo tee -a /etc/modules
```
* Nel file `/etc/modprobe.d/blacklist.conf`, aggiungere un'esclusione per il
  driver confliggente:
```
cat <EOF | sudo tee -a /etc/modprobe.d/blacklist.conf
# Blacklisto il driver intel hdmi
blacklist snd_hdmi_lpe_audio
EOF
```
* Riavviare il sistema;
* Dopo il riavvio, accedere al pannello di configurazione dell'audio (clic
  sinistro, *Mixer audio* oppure a linea di comando lanciando il comando
`pavucontrol`) e selezionare come dispositivo di output per la riproduzione
*Speaker* (con gli altri canali non funziona).

## Linuxium ##

Il sito web [Linuxium](http://linuxiumcomau.blogspot.com/) si presenta come
una buona fonte di informazioni sul supporto con Linux delle piattaforme Intel
Cherry Trail (Atom Z8500). L'autore ha lavorato su diversi fix per i
principali problemi segnalati sopra e ha preparato uno script (`isorespin.sh`)
per *patchare* l'immagine ISO di installazione di diversi sistemi Ubuntu-based
(anche Mint).

Utilizzando lo script indicato con l'immagine iso di Xubuntu 18.04 LTS «Bionic
Beaver» a 64 bit, l'unico risultato che si ottiene è quello di avere la scheda
wireless funzionante già dall'installazione.

## Altre risorse ##

* [Linuxium `isorespin.sh` script](http://linuxiumcomau.blogspot.com/2018/04/latest-improvements-to-isorespinsh.html): aggiunge supporto per Intel Cherry Trail, su cui si basa la VM alle distro Ubuntu-based e Mint;
* [Documentazione dello script `isorespin.sh`](http://linuxiumcomau.blogspot.com/2017/06/customizing-ubuntu-isos-documentation.html)
* [File dei firmware per BCM43430](http://jwrdegoede.danny.cz/brcm-firmware/)
* [Repository dei fix per l'audio](https://github.com/plbossart/UCM)
* [Repository per i fix BlueTooth](https://github.com/lwfinger/rtl8723bs_bt)

## Fix personali per Ubuntu ##

Eseguire lo script come segue:

	sudo bash fixes.sh <oggetto>

Dove `<oggetto>` può essere uno dei seguenti fix:

* `wireless`: scarica il file mancante che istruisce il firmware a caricarsi,
  quindi scarica e ricarica il modulo del kernel;
* `audio`: sistema il file principale di PulseAudio per far funzionare
  l'audio. &Egrave; necessario un riavvio per il corretto funzionamento;
