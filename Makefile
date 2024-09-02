
all: index.html gentleboost.html evaluating-cdfs.html a-simple-feature-store.html maturin-binaries.html

clean:
	rm -f index.html

index.html: index.md template.html Makefile
	pandoc --toc -s --css reset.css --css dracula-highlighting.css --css index.css -i $< -o $@ --template=template.html

gentleboost.html: gentleboost.md template.html Makefile
	pandoc --toc -s --highlight-style dracula.theme --css reset.css --css dracula-highlighting.css --css index.css -i $< -o $@ --template=template.html

evaluating-cdfs.html: evaluating-cdfs.md template.html Makefile
	pandoc --toc -s --highlight-style dracula.theme --css reset.css --css dracula-highlighting.css --css index.css -i $< -o $@ --template=template.html

a-simple-feature-store.html: a-simple-feature-store.md template.html Makefile
	pandoc --toc -s --highlight-style dracula.theme --css reset.css --css dracula-highlighting.css --css index.css -i $< -o $@ --template=template.html

maturin-binaries.html: maturin-binaries.md template.html Makefile
	pandoc --toc -s --highlight-style dracula.theme --css reset.css --css dracula-highlighting.css --css index.css -i $< -o $@ --template=template.html

.PHONY: all clean
