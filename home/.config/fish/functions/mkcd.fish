function mkcd --description 'Make directory and cd into it'
	mkdir -p $argv
	cd $argv[-1]
end
