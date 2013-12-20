commendies = Category.create(name: 'TV Commedies')
dramas = Category.create(name: 'TV Dramas')
reality = Category.create(name: 'Reality TV')

Video.create(title: "Family Guy", description: "Peter griffin and talking dog", small_cover_url: "/tmp/family_guy.jpg", category: commendies)
Video.create(title: "Futurama", description: "Space travel!", small_cover_url: "/tmp/futurama.jpg", category: dramas)
Video.create(title: "Monk", description: "Paranoid SF detective", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg", category: dramas)
Video.create(title: "South Park", description: "Hippie kides", small_cover_url: "/tmp/south_park.jpg", category: reality)

