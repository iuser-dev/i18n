#!/usr/bin/env coffee

> ./transalte.js:Transalte
  @u7/read.js
  fs > readFileSync existsSync
  @u7/xxhash3-wasm > hash128
  @u7/write.js
  utax/u8.js > u8eq
  ./j2f.js

str2id = (s)=>
  n = -1
  map = new Map()
  [
    s.replace(
      /(\${[a-zA-Z_]+})/g
      (a)=>
        map.set(++n, a[2..-2])
        '_'+n+'_'
    )
    map
  ]

id2str = (s,m)=>
  s.replaceAll('__','_')
   .replace(
     /(_\d+):/g
    (id)=>
      id[..-2]+'_ :'
   )
   .replace(
     /(_ \d+)/g
    (id)=>
      '_'+id[1..].trim()
   )
   .replace(
     /(\d+ _)/g
    (id)=>
      id[..-2].trim()+'_'
   )
   .replace(
     /(_\d+)$/mg
     (id)=>
      id.trimEnd()+'_'
   )
   .replace(
     /(^\d+_)/mg
     (id)=>
       '_'+id.trimStart()
   )
   .replace(
     /(_\d+ )/g
     (id)=>
      id.trimEnd()+'_ '
   )
   .replace(
     /( \d+_)/g
     (id)=>
       ' _'+id.trimStart()
   )
   .replace(
    /(_\d+_)/g
    (id)=>
      ' ${'+m.get(
        parseInt id[1...-1]
      )+'} '
  ).replace(
    / +/g
    ' '
  )

< (to_lang, src, fp, exist_fp, path)=>
  src_fp = path src, fp
  txt = read(src_fp)
  hash = hash128 txt
  if existsSync exist_fp
    if u8eq hash, readFileSync(exist_fp)
      write(
        path 'zh-TW', fp
        j2f read path 'zh',fp
      )
      return

  transalte = Transalte src
  [md,map] = str2id txt
  for to from to_lang

    if to == src
      continue

    if to == 'zh-TW'
      continue

    console.log to
    out = (
      (await transalte(to, [md])).map (s)=>
        id2str(s,map)
    ).join('')

    write(
      path(to, fp)
      out
    )

    if to == 'zh'
      write(
        path('zh-TW', fp)
        j2f out
      )

  write(
    exist_fp
    hash
  )
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

