COMMON_SOURCES=midi_test.s planck.cfg

rom.bin: $(COMMON_SOURCES)
	cl65 --listing rom-listing.txt \
	--mapfile rom-labelmap.txt \
	--config planck.cfg \
	--target none \
	-v \
	-O \
	--cpu 65C02 \
	-o $@ \
	$<
