import re
import sys
import os


def _grep(paths, pattern):
    all_found = {}
    repat = re.compile(pattern)

    def _find_tab_char(filename):
        found = []
        with open(filename, 'rt') as f:
            for lineno, line in enumerate(f):
                if repat.findall(line):
                    found.append(' '.join((str(lineno), line.strip('\n'))))
        return found

    for path in paths:
        found = _find_tab_char(path)
        if found:
            all_found[path] = found

    return all_found


def _print_grep_result(all_found):
    for fn in all_found:
        print fn
        for line in all_found[fn]:
            print ' ', line


def _print_tips(content):
    print 'TIPS: {0}'.format(content)


def lint_check_tab_char(paths):
    found = _grep(paths, '\t')
    if found:
        _print_tips('Must use spaces instead of tab char')
        _print_grep_result(found)
        return False
    return True


def lint_check_numbers_of_order_last(paths):
    found = _grep(paths, '- order: last')
    many_last = {k: v for k, v in found.iteritems() if len(v) == 2}

    if many_last:
        _print_tips("Only one '- order: last' takes effect, use only one"
                    " of that and replace other with specific requisite"
                    " (you may want to require ``sls: sls_file`` instead)")
        _print_grep_result(many_last)
        return False
    return True


def process_args():
    filepath = sys.argv[1]
    if os.path.isdir(filepath):
        paths = []
        for root, dirs, fns in os.walk(filepath):
            # skip dot files / dirs
            fns = [f for f in fns if not f[0] == '.']
            dirs[:] = [d for d in dirs if not d[0] == '.']
            for fn in fns:
                paths.append(os.path.join(root, fn))
    else:
        paths = sys.argv[1:]

    return paths


if __name__ == "__main__":
    paths = process_args()
    res = []
    res.append(lint_check_tab_char(paths))
    res.append(lint_check_numbers_of_order_last(paths))
    no_of_false = [i for i in res if i is False]
    sys.exit(no_of_false)
