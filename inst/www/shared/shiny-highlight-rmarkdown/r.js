/* Modified from highlight.js/11.2.0/languages/r.min.js */

hljs.registerLanguage("r", (() => {
    "use strict"; function e(e) {
        return e ? "string" == typeof e ? e : e.source : null
    } function n(...n) {
        return "(" + ((e => {
            const n = e[e.length - 1]
                ; return "object" == typeof n && n.constructor === Object ? (e.splice(e.length - 1, 1), n) : {}
        })(n).capture ? "" : "?:") + n.map((n => e(n))).join("|") + ")"
    } return a => {
        const s = /(?:(?:[a-zA-Z]|\.[._a-zA-Z])[._a-zA-Z0-9]*)|\.(?!\d)/, i = n(/0[xX][0-9a-fA-F]+\.[0-9a-fA-F]*[pP][+-]?\d+i?/, /0[xX][0-9a-fA-F]+(?:[pP][+-]?\d+)?[Li]?/, /(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?[Li]?/), t = /[=!<>:]=|\|\||&&|:::?|<-|<<-|->>|->|\|>|[-+*\/?!$&|:<=>@^~]|\*\*/, r = n(/[()]/, /[{}]/, /\[\[/, /[[\]]/, /\\/, /,/)
            ; return {
                name: "R", keywords: {
                    $pattern: s,
                    keyword: "function if in break next repeat else for while",
                    literal: "NULL NA TRUE FALSE Inf NaN NA_integer_|10 NA_real_|10 NA_character_|10 NA_complex_|10",
                    built_in: "return switch try tryCatch stop warning require library attach detach source setMethod setGeneric setGroupGeneric setClass setRefClass R6Class UseMethod NextMethod"
                }, contains: [a.COMMENT(/#'/, /$/, {
                    contains: [{
                        scope: "doctag", match: /@examples/,
                        starts: {
                            end: (c = n(/\n^#'\s*(?=@[a-zA-Z]+)/, /\n^(?!#')/), ((...n) => n.map((n => e(n))).join(""))("(?=", c, ")")),
                            endsParent: !0
                        }
                    }, {
                        scope: "doctag", begin: "@param", end: /$/, contains: [{
                            scope: "variable", variants: [{ match: s }, { match: /`(?:\\.|[^`\\])+`/ }], endsParent: !0
                        }]
                    }, { scope: "doctag", match: /@[a-zA-Z]+/ }, { scope: "keyword", match: /\\[a-zA-Z]+/ }]
                }), a.HASH_COMMENT_MODE, {
                    scope: "string", contains: [a.BACKSLASH_ESCAPE],
                    variants: [a.END_SAME_AS_BEGIN({
                        begin: /[rR]"(-*)\(/, end: /\)(-*)"/
                    }), a.END_SAME_AS_BEGIN({
                        begin: /[rR]"(-*)\{/, end: /\}(-*)"/
                    }), a.END_SAME_AS_BEGIN({
                        begin: /[rR]"(-*)\[/, end: /\](-*)"/
                    }), a.END_SAME_AS_BEGIN({
                        begin: /[rR]'(-*)\(/, end: /\)(-*)'/
                    }), a.END_SAME_AS_BEGIN({
                        begin: /[rR]'(-*)\{/, end: /\}(-*)'/
                    }), a.END_SAME_AS_BEGIN({ begin: /[rR]'(-*)\[/, end: /\](-*)'/ }), {
                        begin: '"', end: '"',
                        relevance: 0
                    }, { begin: "'", end: "'", relevance: 0 }]
                }, {
                    relevance: 0, variants: [{
                        scope: {
                            1: "operator", 2: "number"
                        }, match: [t, i]
                    }, {
                        scope: { 1: "operator", 2: "number" },
                        match: [/%[^%]*%/, i]
                    }, { scope: { 1: "punctuation", 2: "number" }, match: [r, i] }, {
                        scope: {
                            2: "number"
                        }, match: [/[^a-zA-Z0-9._]|^/, i]
                    }]
                }, {
                    scope: { 3: "operator" },
                    match: [s, /\s+/, /<-/, /\s+/]
                }, {
                    scope: "operator", relevance: 0, variants: [{ match: t }, {
                        match: /%[^%]*%/
                    }]
                }, { scope: "punctuation", relevance: 0, match: r }, {
                    begin: "`", end: "`",
                    contains: [{ begin: /\\./ }]
                }]
            }; var c
    }
})());
