#!/usr/bin/env coffee

> @u7/walk > walkRel
  @u7/write.js
  @u7/read.js
  utax/u8.js > u8eq
  @u7/it > loads dumps
  @u7/wasm-set > BinSet
  fs > readFileSync existsSync
  path > join
  ./lang_li.js
  ./j2f.js
  ./transalte.js:Transalte
  ./md.js
  @u7/xxhash3-wasm > hash128

concat = (a,b)=>
  len = a.length
  r = new Uint8Array(len + b.length)
  r.set(a)
  r.set(b, len)
  r

_dict_li = (prefix, ob, li, hash)=>
  for [k,v] from Object.entries(ob)
    if v
      if typeof(v) == 'string'
        key = prefix.concat [k]
        li.push [hash(key,v), key, v]
      else
        _dict_li prefix.concat([k]),v,li,hash
  return

dict_li = (ob,hash)=>
  li = []
  _dict_li [],ob,li,hash
  li

get = (o, key_li)=>
  for i from key_li
    t = o[i]
    if not t
      return
    o = t
  t

set = (o, key_li, val)=>
  n = key_li.length - 1
  i = 0
  while i < n
    key = key_li[i++]
    t = o[key]
    if not t
      o[key] = t = {}
    o = t
  o[key_li[n]] = val
  return

load = (fp)=>
  if existsSync fp
    loads read fp
  else
    {}

json = 'json'

dumpJson = (fp, it)=>
  write(join(json,fp[..-3]+json), JSON.stringify(it))

it2json = (src, fp, exist_fp, path)=>
  exist_fp = join json, exist_fp
  if existsSync exist_fp
    exist = BinSet.load readFileSync(exist_fp), 16
  else
    exist = new BinSet

  now = new BinSet

  for lang from LangLi
    ifp = path(lang, fp)
    if ifp != src
      if existsSync ifp
        txt = read ifp
        hash = hash128 txt
        now.add hash
        if exist.has hash
          continue
        await dumpJson ifp, loads(txt)
  write(
    exist_fp
    now.dump()
  )
  return

i18n = (to, src, fp, exist_fp, path)=>
  src_fp = path src, fp
  console.log '##', src_fp
  file_txt = read src_fp
  file_hash = hash128 file_txt

  if existsSync exist_fp
    bin = readFileSync(exist_fp)

    if u8eq file_hash, bin[..15]
      write(
        path 'zh-TW', fp
        j2f read(path 'zh', fp)
      )
      it2json src, fp, exist_fp, path
      return
    exist = BinSet.load bin[16..],16
  else
    exist = new BinSet

  it = loads file_txt
  await dumpJson src_fp, it

  li = dict_li it, (key_li, txt)=>
    hash128 "#{key_li.join(':')}\n#{txt}"

  transalte = Transalte src

  out = (fp, it)=>
    write(fp, dumps it)
    await dumpJson fp, it

  for lang from to
    if lang == 'zh-TW'
      continue
    #if lang == 'sk'
    #  continue
    if lang != src
      ofp = path lang, fp
      console.log '## '+lang+'\n'
      o = load(ofp)
      it = {}
      todo_key = []
      todo_li = []
      for [hash, key_li, txt] in li
        if exist.has(hash)
          r = get(o, key_li)
          if r
            set it, key_li, r
            continue
        todo_key.push key_li
        todo_li.push txt

      if todo_li.length
        for i,pos in await transalte lang,todo_li
          console.log todo_li[pos]
          console.log i+'\n'
          set it, todo_key[pos], i
      await out ofp, it

  await out(
    path 'zh-TW', fp
    loads j2f read path('zh',fp)
  )

  exist = new BinSet
  li.map ([i])=>
    exist.add(i)
    return

  write exist_fp, concat(
    file_hash
    exist.dump()
  )
  return

< (dir,src,to)=>
  console.log '#',dir
  if to
    to = to.split(':')
  else
    to = LangLi
  process.chdir dir
  ext = '.it'
  _i18n = '.i18n'

  root = join(dir,src)
  if existsSync root
    for await fp from walkRel root
      if not fp.endsWith ext
        if fp.endsWith '.md'
          await md(
            to
            src
            fp
            join(src, _i18n, fp[..-4])
            (lang, fp)=>join(lang, fp)
          )
        continue
      await i18n(
        to
        src
        fp
        join(src, _i18n, fp)
        (lang, fp)=>join(lang, fp)
      )

  it = root+ext
  if existsSync it
    await i18n(
      to
      src
      src+ext
      join(_i18n, src+ext)
      (lang, fp)=>join(lang+ext)
    )

  console.log 'done'
  return
