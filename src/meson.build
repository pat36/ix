ix_sources = [
	'ix.vala',
]
ix_deps = [
	dependency('gio-2.0', version: '>= 2.50'),
	dependency('gtk+-3.0', version: '>= 3.22'),
]

gnome = import('gnome')

executable('ix', ix_sources,
  vala_args: '--target-glib=2.50',  dependencies: ix_deps,
  install: true,
)
