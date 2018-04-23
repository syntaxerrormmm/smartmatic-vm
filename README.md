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
* Scheda audio: il chipset è Realtek 5640, il driver è nel kernel ma
  PulseAudio si rifiuta di utilizzarlo. Sono necessari dei [file
aggiuntivi](https://github.com/plbossart/UCM/tree/master/bytcr-rt5640);
* Scheda BlueTooth: ND
* Stampante termica: ND
* Regolazione della luminosità: non funzionante con sistema nativo. Non sono
  stati effettuati altri test

## Linuxium ##

Il sito web [Linuxium](http://linuxiumcomau.blogspot.com/) si presenta come
una buona fonte di informazioni sul supporto con Linux delle piattaforme Intel
Cherry Trail (Atom Z8500).

Alcune risorse interessanti:

* [Linuxium `isorespin.sh` script](http://linuxiumcomau.blogspot.com/2018/04/latest-improvements-to-isorespinsh.html): aggiunge supporto per Intel Cherry Trail, su cui si basa la VM alle distro Ubuntu-based e Mint;
* [Documentazione dello script `isorespin.sh`](http://linuxiumcomau.blogspot.com/2017/06/customizing-ubuntu-isos-documentation.html)
* [File dei firmware per BCM43430](http://jwrdegoede.danny.cz/brcm-firmware/)
* [Repository dei fix per l'audio](https://github.com/plbossart/UCM)

## Fix personali per Ubuntu ##

Eseguire lo script come segue:

	sudo bash fixes.sh <oggetto>

Dove `<oggetto>` può essere uno dei seguenti fix:

* `wireless`: scarica il file mancante che istruisce il firmware a caricarsi,
  quindi scarica e ricarica il modulo del kernel;
