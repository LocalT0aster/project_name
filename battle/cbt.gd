extends TextureRect

signal done

func process(_cmd):
	done.emit()
