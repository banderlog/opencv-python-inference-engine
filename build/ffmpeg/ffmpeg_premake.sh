#!/bin/bash
# Build ffmpeg shared libraries without version suffix
# from <https://stackoverflow.com/a/36937360/7599215>

OLD1='SLIBNAME_WITH_VERSION=$(SLIBNAME).$(LIBVERSION)'
OLD2='SLIBNAME_WITH_MAJOR=$(SLIBNAME).$(LIBMAJOR)'
OLD3='SLIB_INSTALL_NAME=$(SLIBNAME_WITH_VERSION)'
OLD4='SLIB_INSTALL_LINKS=$(SLIBNAME_WITH_MAJOR) $(SLIBNAME)'

NEW1='SLIBNAME_WITH_VERSION=$(SLIBNAME)'
NEW2='SLIBNAME_WITH_MAJOR=$(SLIBNAME)'
NEW3='SLIB_INSTALL_NAME=$(SLIBNAME)'
NEW4='SLIB_INSTALL_LINKS='


sed -i -e "s/${OLD1}/${NEW1}/" -e "s/${OLD2}/${NEW2}/" -e "s/${OLD3}/${NEW3}/" -e "s/${OLD4}/${NEW4}/" ./ffbuild/config.mak
