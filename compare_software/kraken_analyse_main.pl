#!/usr/bin/perl
#perl kraken_analyse.pl metadata.label kraken.species kraken.sensitivity
system("./kraken_analyse_1.pl metadata1.no.quick.1.labels kraken.species1 kraken.sensitivity &");
system("./kraken_analyse_1.pl metadata1.no.quick.2.labels kraken.species2 kraken.sensitivity &");
system("./kraken_analyse_1.pl metadata1.no.quick.3.labels kraken.species3 kraken.sensitivity &");
system("./kraken_analyse_1.pl metadata1.no.quick.4.labels kraken.species4 kraken.sensitivity &");
