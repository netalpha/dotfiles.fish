function jvm -d "auto-set JAVA_HOME"
	while set -q argv[1]
		switch $argv[1]
			case '-h' '--help'
				echo "
NAME:
  jvm - The Java Version Manager

USAGE:
  jvm command [command-options]

AUTHOR(S):
  Carlos Alexandro Becker (caarlos0@gmail.com)

COMMANDS:
  local   <version> sets the given version to current folder
  global  <version> sets the given version globally
  version           shows the version being used
  help              displays this help"

			case 'local'
				echo $argv[2] >.java-version
				__jvm_main
				echo (set_color purple)java $argv[2] set for (pwd)
				return 0

			case 'global'
				echo $argv[2] >~/.java-version
				__jvm_main
				echo (set_color purple)java $argv[2] set for (whoami)
				return 0

			case 'version'
				__jvm_get_version
				return 0

			case '*'
				echo (set_color red)invalid option: $argv[1]
				return 1
		end
	end

	__jvm_main
end

function __jvm_main --on-variable PWD
	set jv (__jvm_get_version)
	if test -z "$jv"
		return
	end
	if test "$jv" -le 8
		set jv "1.$jv"
	end
	set -g -x JAVA_HOME (/usr/libexec/java_home -v "$jv")
end

function __jvm_get_version
	test -f ~/.java-version
		and cat ~/.java-version
		and return

	test -f .java-version
		and cat .java-version
		or echo
end

