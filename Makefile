clean:
	rm -r doc/
	mkdir doc

.PHONY: doc
doc:
	ldoc -c config.ld .