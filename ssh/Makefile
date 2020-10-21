all:
	ansible  all --limit master -i inventory  -m package -a "name=ansible state=present"
	ansible  all --limit master -i inventory  -m package -a "name=git state=present"
