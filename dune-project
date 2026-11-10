(lang dune 3.17)
(name mpi)
(generate_opam_files true)
(using mdx 0.4)

(source (github mpi-informatique/lib))
(authors "MPI informatique")
(maintainers "MPI informatique")

(package
 (name mpi)
 (synopsis "Bibliothèque pédagogique pour MP2I et MPI")
 (depends
  (ocaml (>= 5.5.2))
  (odoc :with-doc)
  (mdx (and :with-test (>= 2.3.0)))))
