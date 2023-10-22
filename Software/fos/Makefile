COMMON_SOURCES=macros.s fat16.s minix.s utils.s forth.s native_words.s headers.s strings.s forth_code/user_words.asc forth_code/forth_words.asc

clean:
	$(RM) *.bin *.o platform/*.o platform/*/*.o *labelmap.txt *listing.txt forth_code/user_words.asc forth_code/forth_words.asc

fos-%.bin: platform/%/main.s platform/%/*/*.s platform/%/memory.cfg $(COMMON_SOURCES)
	cl65 --listing $*-listing.txt \
	--mapfile $*-labelmap.txt \
	--config platform/$*/memory.cfg \
	--target none \
	-v \
	-O \
	--cpu 65C02 \
	-o $@ \
	$<

cf-%.bin: platform/%/cf.s platform/%/*/*.s platform/%/cf.cfg $(COMMON_SOURCES)
	cl65 --listing $*-cflisting.txt \
	--mapfile $*-cflabelmap.txt \
	--config platform/$*/cf.cfg \
	--target none \
	-v \
	-O \
	--cpu 65C02 \
	-o $@ \
	$<

rom-%.bin: platform/%/boot.s platform/%/*/*.s platform/%/cf.cfg $(COMMON_SOURCES)
	cl65 --listing $*-romlisting.txt \
	--mapfile $*-romlabelmap.txt \
	--config platform/$*/boot.cfg \
	--target none \
	-v \
	-O \
	--cpu 65C02 \
	-o $@ \
	$<

hex-%.bin: platform/%/hex.s platform/%/memory.cfg $(COMMON_SOURCES)
	cl65 --listing $*-listing.txt \
	--mapfile $*-labelmap.txt \
	--config platform/$*/memory.cfg \
	--target none \
	-v \
	-O \
	--cpu 65C02 \
	-o $@ \
	$<

hex-test.hex: hex-planck.bin
	bin2hex hex-planck.bin hex-test.hex 0x9000

sim:	fos-py65mon.bin
	py65mon -m 65c02 -r fos-py65mon.bin


# Convert the high-level Forth words to ASCII files that ca65 can include with .incbin
forth_code/%.asc: forth_code/%.fs
	$(PYTHON) forth_code/forth_to_bin.py -i $< > $@