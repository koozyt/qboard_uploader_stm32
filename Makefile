PACKAGE_JSON=package_qboard_uploader.json
ARCHIVE_WINDOWS=dfutil-stm32-qboard-0.8.0-windows.tar.bz2

all: build_win/${PACKAGE_JSON}

build_win/${ARCHIVE_WINDOWS}: dfutil-stm32-koozyt/dfu-util.exe
	tar cjf build_win/${ARCHIVE_WINDOWS} dfutil-stm32-koozyt

build_win/stm-shsum: build_win/${ARCHIVE_WINDOWS}
	cd build_win && shasum -a 256 ${ARCHIVE_WINDOWS} | cut -d' ' -f1 > stm-shsum

build_win/stm-size: build_win/${ARCHIVE_WINDOWS}
	cd build_win && ls -l ${ARCHIVE_WINDOWS} | cut -d' ' -f5 > stm-size

build_win/${PACKAGE_JSON}: packaging/${PACKAGE_JSON} build_win/stm-shsum build_win/stm-size
	sed -e "s/%%CHECKSUM%%/`cat build_win/stm-shsum`/" -e "s/%%SIZE%%/`cat build_win/stm-size`/" < packaging/${PACKAGE_JSON} > build_win/${PACKAGE_JSON}

dfutil-stm32-koozyt/dfu-util.exe: dfu-util/src/dfu-util.exe
	cd dfu-util && make && cp src/dfu-util.exe ../dfutil-stm32-koozyt/
