#!/bin/bash
date +'%d/%m/%Y %H:%M:%S' > /Users/Shared/Enhancements/macports_updater/macports.out.log
echo ' ' >> /Users/Shared/Enhancements/macports_updater/macports.out.log
date +'%d/%m/%Y %H:%M:%S' > /Users/Shared/Enhancements/macports_updater/macports.err.log
echo ' ' >> /Users/Shared/Enhancements/macports_updater/macports.err.log
bash -c '/opt/local/bin/port selfupdate ; /opt/local/bin/port -puN upgrade outdated ; /opt/local/bin/port uninstall inactive ; /opt/local/bin/port uninstall leaves'
