function vi --description 'Launch preferred vi implementation'
	if set -q EDITOR
		command $EDITOR $argv
	else
		command vi $argv
	end
end
