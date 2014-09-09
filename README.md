armdicto-hack
=============

bringing dictionary to the 21 century.


In 2000-2001 there was a Windows/x86 only English to Armenian dictionary program which contained ~26000 translations.

This hack brings the database to our time.

We need it on ARM, on other platforms than Wintel. Thus now, after figuring out how the database works and fixing database bugs (yep, I found some) we can use the dictionary on any platform and almost any os.

some info about this work in Armenian [here](http://norayr.arnet.am/weblog/2014/09/09/) - with screenshots and explanations.

As it is obvious frem the [screenshot](http://norayr.arnet.am/weblog/wp-content/uploads/2014/09/armdicto_about.png) special thanks to Lusine Harutiunian and Anna Mkhitarian. I guess they have compiled the dictionary initially.

This is how dictionary [looks](http://norayr.arnet.am/weblog/wp-content/uploads/2014/09/20140909143744.jpg) on my Jolla Sailfish device.

prerequisites
=============

* gnu coreutils - standnard gnu file utilities
* bash          - the standard gnu bourne again shell
* wget          - network utility to retrieve files from www
* rar           - rar compressor/uncompressor
* unshield      - installshieald cab file extractor
* gnu make      - standard tool to compile source trees
* voc           - vishap oberon compiler
* stardict      - international dictionary supporting fuzzy and glob style matching

stardict itself is not necessary to use produced dictionaries. many other dictionaries support produced format. stardict is necessary in order to produce dictionary files. we use stardict_tabfile utility in order to convert generated tab separated file into dictionary form.

in order to get stardict_tabfile on Gentoo like systems one needs to emerge stardict with "tools" USE flag set.

run hack yourself
=================
>bash run.sh

using
=====
in order to use produced dictionary with stardict issue

>cp -a armdicto ~/.stardict/dic/

if there's no such directory, then create it.

in order to use these files with other dictionary software you need to copy them to corresponding directories. for example, for Sidudict under SailfishOS it's

>~/.local/share/harbour-sidudict/

mstardict for maemo fremantle searches dictionaries in

>~/.MyDocs/mstardict

there is also software for android which you can use these dictionary files with.

enjoy! (:

