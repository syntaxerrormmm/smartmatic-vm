# Materiale per le Voting Machine SmartMatic #

## Hardware ##

Le cosiddette Voting Machine sono, più correttamente, dei sistemi SmartMatic
VIU-800 (Voter Identification Unit).

Alcune informazioni sull'hardware:

* [Pagina della CPU su sito Intel](https://ark.intel.com/it/products/87383/Intel-Atom-x5-Z8300-Processor-2M-Cache-up-to-1_84-GHz)
* [FCC-ID: Materiale su VIU-800](https://fccid.io/2AGVK-VIU-800)
* [FCC-ID: Disassemblamento del VIU-800](https://fccid.io/2AGVK-VIU-800/Internal-Photos/Internal-photos-3266464.html);
* [Pagina del dispositivo su SmartMatic](http://www.smartmatic.com/voting/hardware/detail/viu-800/)


## Fix personali per Ubuntu ##

Eseguire lo script come segue:

	sudo bash fixes.sh <oggetto>

Dove `<oggetto>` può essere uno dei seguenti fix:

* `wireless`: scarica il file mancante che istruisce il firmware a caricarsi,
  quindi scarica e ricarica il modulo del kernel;


## Linuxium ##

* [Linuxium `isorespin.sh` script](http://linuxiumcomau.blogspot.com/2018/04/latest-improvements-to-isorespinsh.html): aggiunge supporto per Intel Cherry Trail, su cui si basa la VM;
* [Documentazione dello script `isorespin.sh`](http://linuxiumcomau.blogspot.com/2017/06/customizing-ubuntu-isos-documentation.html)
