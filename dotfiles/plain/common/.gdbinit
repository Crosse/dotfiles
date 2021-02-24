python
import glob, os

gdbinit_path = os.path.expanduser('~/.gdbinit.d/')

for f in glob.iglob(os.path.join(gdbinit_path, '*.gdb')):
  print 'sourcing %s' % f
  gdb.execute('source %s' % f)
for f in glob.iglob(os.path.join(gdbinit_path, '*.py')):
  print 'sourcing %s' % f
  gdb.execute('source %s' % f)
end
