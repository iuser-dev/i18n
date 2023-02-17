#!/usr/bin/env coffee

> utax/sleep.js
  @vitalets/google-translate-api:translate
# ../i18n.js > I18nClient
# path > join
# util > promisify
#@grpc/grpc-js:grpc
#client = new I18nClient("127.0.0.1:5900",  grpc.credentials.createInsecure())


rename = {
  zh:'zh-CN'
  fil:'tl'
}

< (src)=>
  src = rename[src] or src
  (to, li)=>
    to = rename[to] or to
    result = []
    if li.length
      opt = {
        from: src
        to
      }
      {i18n_tld} = process.env
      if i18n_tld
        opt.tld = i18n_tld
      for i from li
        retry = 9
        loop
          try
            {text} = await translate(i, opt)
            text = text.trim()
            if text.indexOf('\n') < 0
              for c from '.|'
                if text.endsWith(c) and not i.endsWith(c)
                  text = text[...-1].trimEnd()
            result.push text
            break
          catch err
            if retry
              --retry
              console.error err
              console.trace to, src, i
              await sleep 3000
            else
              throw err
            await sleep 100
    result

