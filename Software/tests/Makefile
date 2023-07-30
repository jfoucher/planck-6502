COMMON_SOURCES=planck.cfg

midi.bin:  midi_test.s $(COMMON_SOURCES) 
	cl65 --listing midi-listing.txt \
	--mapfile midi-labelmap.txt \
	--config planck.cfg \
	--target none \
	-v \
	-O \
	--cpu 65C02 \
	-o $@ \
	$<

vga.bin:  vga_test.s $(COMMON_SOURCES)
	cl65 --listing vga-listing.txt \
	--mapfile vga-labelmap.txt \
	--config planck.cfg \
	--target none \
	-v \
	-O \
	--cpu 65C02 \
	-o $@ \
	$<