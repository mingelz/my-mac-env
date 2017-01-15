/**
 * docs: http://eslint.org/docs/rules/[rule-name]
 * applicable: eslint v3.13.1
 * update: 2017-1-15
 * author: mingelz
 */

module.exports = {
  "root": true,

  "extends": "eslint:recommended",                // 可以在这里引用一个成熟的检测方案，如果下边每条细节都指定，则这行可以省略
  "plugins": [],
  "settings": {},                                 // 共享数据配置，这里配置的数据会传给每个 Rules

  "env": {                                        // 代码可能运行的环境，及全局变量定义
    "browser": true,
    "node": true,
    "es6": true,                                  // ES6 特性，这个设置会修改 ecmaVersion 配置项为 6

    "commonjs": false,
    "shared-node-browser": false,                 // Node 和 Browser 中一些通用的全局变量
    "worker": false,                              // Web Workers
    "amd": false,
    "mocha": false,
    "jasmine": false,
    "jest": false,
    "phantomjs": false,
    "protractor": false,
    "qunit": false,
    "jquery": false,
    "prototypejs": false,
    "shelljs": false,
    "meteor": false,
    "mongo": false,
    "applescript": false,
    "nashorn": false,
    "serviceworker": false,
    "atomtest": false,
    "embertest": false,
    "webextensions": false,
    "greasemonkey": false,
  },
  "globals": {                                    // 全局变量，只要 key 存在，就表示全局变量存在，对应的值为 false 表示此全局变量不允许被重写
    // "foo": true,
    // "bar": false,
  },

  "parser": "espree",                             // js 解析器，默认 Espree, 另有 Esprima, Esprima-FB, Babel-ESLint
  "parserOptions": {
    "ecmaVersion": 6,                             // 6 表示 ES2015，另外还可以用 3/5/6/7/8 或 ES 年份来表示
    "sourceType": "module",                       // 源码模式，默认为 `script`，如果使用 ES Module，则设置为 `module`
    "ecmaFeatures": {                             // 针对一些特性支持情况
      "globalReturn": false,                      // 允许在全局作用域下使用 return 语句
      "impliedStrict": false,                     // 启用全局 strict mode，仅在 ES2015 以上有效
      "jsx": false,                               // 是否支持 JSX
      "experimentalObjectRestSpread": true,       // 启用 Object Rest/Spread 支持，这是一个 ES2016 中的实验性功能，但好用到爆
    }
  },

  "rules": {
    // Possible Errors
    "no-await-in-loop": 2,                        // 不允许在循环中使用 await，建议将所有的 await 给 `Promise.all` 统一 await
    "no-cond-assign": [2,                         // 不允许在条件语句中使用赋值语句 `if (x = 1)`
      "always",
    ],
    "no-console": 1,                              // 不允许有 console
    "no-constant-condition": 2,                   // 不允许在条件语句中使用静态判断 `if (true)`
    "no-control-regex": 2,                        // 不允许在正则中使用控制字符(ASCII 0~31) `new RegExp("\x1f")`
    "no-debugger": 2,                             // 不允许有 debugger
    "no-dupe-args": 2,                            // 函数参数名不允许重复 `function foo (a, b, a)`
    "no-dupe-keys": 2,                            // 对象的 key 不允许重复
    "no-duplicate-case": 2,                       // switch case 语句语句的条件不允许重复
    "no-empty": [2,                               // 不允许使用空的语句块 `if (foo) {}`
      {
        "allowEmptyCatch": true,                  // 允许空的 catch 语句
      },
    ],
    "no-empty-character-class": 2,                // 正则中不允许使用空字符类 `var foo = /^abc[]/`
    "no-ex-assign": 2,                            // 不允许覆写 catch 语句的参数 `try {} catch (e) { e = 10 }`
    "no-extra-boolean-cast": 2,                   // 在条件判断语句中不允许使用不必要的布尔转换 `if (!!foo)`
    "no-extra-parens": [2,                        // 不允许多余的括号 `var foo = (1 + 2)`
      "functions",                                // 仅检测函数表达式的多余括号，如果设置为 all，则可以在下边调整细节配置
      {
        "conditionalAssign": false,               // 条件表达式中
        "returnAssign": false,                    // return 后的表达式
        "nestedBinaryExpressions": false,         // 多个二元表达式连写的情况
      },
    ],
    "no-extra-semi": 2,                           // 不允许多余的分号 `function foo {};`
    "no-func-assign": 2,                          // 不允许对函数名重新赋值
    "no-inner-declarations": [2,                  // 不允许在无独立作用域的块语句内声明函数和变量
      "both",
    ],
    "no-invalid-regexp": 2,                       // 不允许无效的正则表达式
    "no-irregular-whitespace": 2,                 // 不允许普通空格和制表符外的其他非常规空格，如零宽空格、换行符
    "no-obj-calls": 2,                            // 不允许直接调用 `Math(), JSON()`
    "no-prototype-builtins": 2,                   // 使用 `Object.create()` 可以给对象一个特别的 prototype，所以建议使用 `{}.hasOwnProperty.call(foo, 'bar')，而不是 `foo.hasOwnProperty('bar')`
    "no-regex-spaces": 2,                         // 在正则中不允许使用连续多个空格，而要用数量限定 `/foo {3}bar/`
    "no-sparse-arrays": 2,                        // 数组中需要指定每一项，不允许多个逗号连续出现 `['foo',,'bar']`
    "no-template-curly-in-string": 2,             // 不允许在字符串里使用模板字符串变量格式，避免本应该使用模板字符串，结果使用了引号
    "no-unexpected-multiline": 2,                 // 不允许多行歧义，在不使用分号的情况下容易出现
    "no-unreachable": 2,                          // 在 return, throw, break, continue 后不允许再有语句
    "no-unsafe-finally": 2,                       // 在 finally 中不允许使用 return, throw, break, continue 等语句，因为会先于 try 执行
    "no-unsafe-negation": 2,                      // in/instanceof 操作符前使用否定语句时要使用括号
    "use-isnan": 2,                               // 使用 `isNaN(foo)` 而不是 `foo == NaN`
    "valid-jsdoc": [0,                            // 检查 JSDoc 语法注释，及其正确性
      {
        // TODO: 有很多细节配置，因为目前 JSdoc 并非首选的文档工具，所以暂时不做配置
      },
    ],
    "valid-typeof": [2,                           // 检查 typeof 后的拼写正确性 `typeof foo === 'nunber'`
      {
        "requireStringLiterals": false,           // typeof 后只能跟 string，此时 `typeof foo === bar` 将不被允许
      },
    ],

    // Best Practices
    "accessor-pairs": 2,                          // 同时提供 getter/setter 方法
    "array-callback-return": 2,                   // 在数组的递归回调函数中需要有 return
    "block-scoped-var": 2,                        // 避免变量影响到语句块外（类C）`if (foo) { var bar = 1 }`
    "class-methods-use-this": 2,                  // 检查 Class 中的方法是否用到了 `this`，如果没用到建议转为 static 方法
    "complexity": [2,                             // 最多有多少个 `if else`
      20,                                         // 默认 20
    ],
    "consistent-return": 2,                       // return 后一定要有值，不能直接写 `return;`
    "curly": [2,                                  // if, else, while, do, for 后是否必须使用大括号
      "multi-line",
      "consistent",
    ],
    "default-case": 2,                            // switch 中是否必须要有 default，可使用 `// no default` 来明确表示无 default
    "dot-location": [2,                           // 有换行时 `.` 操作符的位置，跟在 'object' 后，还是 'property' 前
      "property",
    ],
    "dot-notation": [2,                           // 对象属性使用 `.` 获取，而不是 [] 获取
      {
        "allowKeywords": true,                    // 是否允许关键字做 key，`foo['class']`
        "allowPattern": "",
      },
    ],
    "eqeqeq": [2,                                 // 使用 `===`，smart 表示两边无类型转换时，可以使用 `==`
      "smart",
    ],
    "guard-for-in": 2,                            // 在 `for in` 中过滤原型链继承属性
    "no-alert": 2,                                // 避免使用 alert, confirm, prompt
    "no-caller": 2,                               // 不允许使用 `arguments.caller` 或 `arguments.caller`
    "no-case-declarations": 2,                    // 不允许在 case 中定义变量和函数，如定义需要用大括号 `case: { let foo = 1 }`
    "no-div-regex": 2,                            // 不允许看起来像除法的正则字面量 `/=foo/` 中 `/=` 像是除法运算符，要写成 `/\=foo/`
    "no-else-return": 2,                          // 如果每个 if 及 if else 都中都有 return，则在 else 中不再需要 return，转为在函数最后 return
    "no-empty-function": [2,                      // 不允许空函数，但如果函数中有注释，并不算空函数
      {
        "allow": ["constructors"],                // 允许空函数出现的地方
      },
    ],
    "no-empty-pattern": 2,                        // 不允许空解构模式，可能是打算写默认值，使用 `=`，不小心写成了 `:`，如 `var {foo: {}} = bar` 为空解构，而 `var {foo = {}} = bar` 是设置默认值
    "no-eq-null": 2,                              // 不允许使用 `==` 判断 null，而要用 `===`
    "no-eval": 2,                                 // 不允许使用 `eval()`
    "no-extend-native": [2,                       // 不允许修改原生对象原型
      {
        "exceptions": ["Object"],                 // 例外
      },
    ],
    "no-extra-bind": 2,                           // 不允许不必要的 bind。比如函数中并没有使用到 `this`，或者箭头函数中
    "no-extra-label": 2,                          // 不允许不必要的 label
    "no-fallthrough": 2,                          // 每个 case 都要 break，可使用 `// falls through` 强制 fallthrough
    "no-floating-decimal": 2,                     // 小数点前后需要用 0 补齐，不允许留空
    "no-global-assign": [2,                       // 不允许重定义内建对象（包括 ES5/ES6/Browser/Node 等环境, https://github.com/sindresorhus/globals/）
      {
        "exceptions": [],                         // 例外
      },
    ],
    "no-implicit-coercion": [0,                   // 不允许隐含的类型转换 `!!foo`, `foo * 1`, `foo += ''`，而使用 `Number(foo)`
      {
        "boolean": true,
        "number": true,
        "string": true,
        "allow": ["!!", "~", "*", "+"],
      },
    ],
    "no-implicit-globals": 2,                     // 不允许有全局的 var 和 function 定义
    "no-implied-eval": 2,                         // 不允许有隐含 eval，如 `setTimeout("alert(1)", 100)`
    "no-invalid-this": 2,                         // 不允许有不清楚上下文的 this
    "no-iterator": 2,                             // 不允许使用 `__iterator__` 属性
    "no-labels": 1,                               // 不允许使用 label
    "no-lone-blocks": 2,                          // 不允许有无意义的 {} 对
    "no-loop-func": 2,                            // 不允许在循环中定义函数
    "no-magic-numbers": 0,                        // 不允许直接使用常量数字
    "no-multi-spaces": [2,                        // 不允许在代码中有连续空格
      {
        "exceptions": {                           // 例外
          "BinaryExpression": false,              // 表达式中 `var foo = 1  +  2`
          "Property": false,                      // 对象属性后
          "VariableDeclarator": false,            // 多行变量定义时的值对齐
          "ImportDeclaration": true,              // es6 import 的对齐
        },
      },
    ],
    "no-multi-str": 2,                            // 不允许使用 `\` 转义多行字符串每行结尾
    "no-new": 2,                                  // new 出的实例一定要赋值给变量
    "no-new-func": 2,                             // 不允许使用 Function 构造函数
    "no-new-wrappers": 2,                         // 不允许使用原始对象构造实例 `var str = new String('Hello world'); typeof str === 'object'`
    "no-octal": 2,                                // 不使用以 0 开头的八进制字面量
    "no-octal-escape": 2,                         // 不对八进制数字做转义，而是使用 Unicode 方式
    "no-param-reassign": [0,                      // 不允许修改函数参数
      {
        "props": false,                           // 参数的属性是否可被修改
      },
    ],
    "no-proto": 2,                                // 不允许使用 __proto__ 属性
    "no-redeclare": 2,                            // 不允许对变量重复定义
    "no-restricted-properties": [0,               // 不允许使用某些属性名或方法名
      {
        "object": "foo",                          // 这一组表示不允许调用 `foo.bar`，当有多个限制时需要重复这个对象
        "property": "bar",
        "message": "Disallowed foo.bar",          // 出错时给出的提示文本
      },
    ],
    "no-return-assign": [2,                       // 不允许 return 后跟表达式
      "except-parens",                            // 除非表达式用括号括起来
    ],
    "no-return-await": 2,                         // 不允许无用的 `return await`
    "no-script-url": 2,                           // 不允许使用 `javascript://` 式的URL
    "no-self-assign": 2,                          // 不允许自赋值 `foo = foo`
    "no-self-compare": 2,                         // 不允许对比自身，`if (x === x)`
    "no-sequences": 2,                            // 不允许使用逗号连接多个表达式
    "no-throw-literal": 2,                        // 不允许 throw 后跟字面量，需要 new Error
    "no-unmodified-loop-condition": 2,            // 不允许在循环中不更改循环判断值（避免死循环）
    "no-unused-expressions": [2,                  // 不允许定义未使用的表达式
      {
        "allowShortCircuit": true,                // 可以使用 `a && b()` 形式的短表达式
        "allowTernary": true,                     // 允许三元表达式
      },
    ],
    "no-unused-labels": 2,                        // 不允许不必要的 label
    "no-useless-call": 2,                         // 不允许不必要的 .call() 和 .apply()
    "no-useless-concat": 1,                       // 不允许多个常量字符串拼接，但换行拼接不受影响
    "no-useless-escape": 2,                       // 不允许不必要的转义，`'\"'` 中的转义就是非必要的
    "no-useless-return": 2,                       // 不允许无用的 return，没太理解这个规则和 `consistent-return` 的区别
    "no-void": 2,                                 // 不允许使用 void
    "no-warning-comments": [1,                    // 不允许出现 TODO, FIXME 等关键字（保证最终产出无未尽项）
      {
        "terms": ["todo", "fixme", "xxx"],        // 不允许出现的关键字列表
      },
    ],
    "no-with": 2,                                 // 不允许使用 with
    "radix": 2,                                   // 必须传入 parseInt 的第2个参数
    "require-await": 2,                           // 对于 async 一定要有 await 语句
    "vars-on-top": 0,                             // 所有变量必须放在作用域顶部
    "wrap-iife": [2,                              // 自执行函数括号放在哪里，`(function(){}())` 或 `(function(){})()`
      "any",                                      // 任意一种都可以，但一定要把函数括起来，不能 `var foo = function(){}()`
      {
        "functionPrototypeMethods": false,        // 使用 `call/apply` 调用时是否要包裹函数
      },
    ],
    "yoda": [2,                                   // 比较表达式是否需要符合自然语义
      "never",                                    // 当使用 always 时就不需要下边两个细节了
      {
        "exceptRange": true,                      // 大小于对比要符合区间性
        "onlyEquality": true,                     // 等于对比变量在左
      },
    ],

    // Strict Mode
    "strict": [2,                                 // 是否要标记 use strict，以及标记的位置
      "safe",
    ],

    // Variables
    "init-declarations": [0,                      // 定义变量的时候需要赋初始值
      "always",
    ],
    "no-catch-shadow": 2,                         // 在 IE8 中 catch 参数名会扩散到外部作用域
    "no-delete-var": 2,                           // 不允许使用 delete 删除使用 var 定义的变量
    "no-label-var": 2,                            // 不允许 label 的名字与变量名相同
    "no-restricted-globals": [2,                  // 不允许调用全局变量名
      "event",
    ],
    "no-shadow": [2,                              // 不允许在子作用域中定义与外部作用域同名的变量
      {
        "builtinGlobals": false,                  // 是否可定义与内置方法/属性同名变量
        "hoist": "functions",                     // 当子作用域在前时，是否可被后边的定义覆盖
        "allow": [],                              // 要排除的关键字
      },
    ],
    "no-shadow-restricted-names": 2,              // 不允许定义的方法名与已有方法相同
    "no-undef": [2,                               // 不允许使用未定义变量
      {
        "typeof": false,                          // 是否针对 typeof 后跟的变量做检测
      },
    ],
    "no-undef-init": 2,                           // 不允许定义一个变量的初始值为 undefined
    "no-undefined": 2,                            // 是否可以使用 undefined
    "no-unused-vars": [1,                         // 检测是否有未被使用的变量和函数
      {
        "vars": "all",                            // 检测所有的变量的使用情况，还是仅检测局部作用域下的变量
        "varsIgnorePattern": "^_",                // 可被忽略的未使用变量匹配正则
        "args": "after-used",                     // 函数参数在未使用前也被认为是未使用变量
        "argsIgnorePattern": "^_",                // 可被忽略的未使用参数匹配正则
        "caughtErrors": "none",                   // catch 参数
        "caughtErrorsIgnorePattern": "",          // 可被忽略的未使用的 catch 参数匹配正则
      },
    ],
    "no-use-before-define": 2,                    // 变量与函数需要先定义再使用

    // Node.js and CommonJS
    "callback-return": [2,                        // Node.js 编程中，建议回调函数调用后都通过 return 返回，要求的回调函数名称在下边数组中列出
      ["callback", "cb", "next", "success", "failure"],
    ],
    "global-require": 2,                          // require 都在代码最前边完成
    "handle-callback-err": [2,                    // 参数标记有 err 时，回调中要有相应的错误处理逻辑
      "^(e|E)rr(or)?$",                           // 参数需要符合以下正则匹配逻辑
    ],
    "no-mixed-requires": [2,                      // 禁止 require 和 其他变量声明混合使用
      {
        "grouping": false,                        // require 是否要按不同引用类型分组。require 分 4 种引用方式：核心模块如 fs、node_modules 如 jquery、文件如 `./utils`、计算值如 `require(getName())`
        "allowCall": false,                       // 是否允许在引用时直接调用，如 `var foo = require(bar)(xxx)`
      },
    ],
    "no-new-require": 2,                          // 不允许在调用 require 时使用 new 构建它，建议分两行写
    "no-path-concat": 2,                          // 不允许使用 __dirname 和 __filename 做字符串拼接，建议使用 path 模块
    "no-process-env": 0,                          // 不在 Node 下使用 `process.env` 获取环境变量
    "no-process-exit": 2,                         // 不允许使用 `process.exit()`，因为它太危险会退出 Node 环境，建议使用抛异常的方式处理错误逻辑，除非真的在项目的最后需要返回给 Shell 结果
    "no-restricted-modules": [0,                  // 禁用否些 Node.js 模块
      // "fs", "assert",                          // 不允许使用的 Node 模块名称
    ],
    "no-sync": 0,                                 // 禁用同步的方法，因为 Node.js 是以异步见长的，高并发下同步方法会带来问题

    // Stylistic Issues
    "array-bracket-spacing": [2,                  // 数组的中括号前后是否要加空格
      "never",
    ],
    "block-spacing": [2,                          // 代码块前后是否要有空格
      "always",
    ],
    "brace-style": [2,                            // 大括号的风格
      "stroustrup",                               // stroustrup 表示 `else` 前不跟 `}`
      {
        "allowSingleLine": true,                  // 有些情况可能只在一行里写
      },
    ],
    "camelcase": [2,                              // 使用驼峰表示变量
      {
        "properties": "always",                   // 对象的属性名是否使用驼峰
      }
    ],
    "capitalized-comments": [0,                   // 注释的首字母是否要大写，也可以针对 line/block 分别设置
      "never",                                    // 首字母不要大写，如果需要大写则设置为 always
      {
        "ignorePattern": "",                      // 要忽略的正则字符串
        "ignoreInlineComments": true,             // 是否忽略行内注释
        "ignoreConsecutiveComments": true,        // 是否忽略连续的单行注释
      },
    ],
    "comma-dangle": [2,                           // 对象和数组最后一个 value 后是否加逗号
      "only-multiline",                           // 只在多行时可以出现
    ],
    "comma-spacing": [2,                          // 逗号前后是否要有空格
      {
        "before": false,
        "after": true,
      },
    ],
    "comma-style": [2,                            // 逗号在前还是在后
      "last",
    ],
    "computed-property-spacing": [2,              // 在 ES2015 中属性名可以使用变量，变量中括号内，是否要有空格
      "never",
    ],
    "consistent-this": [2,                        // 给 this 一个专门的名字，保持连贯性
      "_this",
    ],
    "eol-last": 0,                                // 文件最后是否要空一行
    "func-call-spacing": [2,                      // 函数调用时函数名与括号中间是否有空格
      "never",                                    // 不允许有空格，需要空格时为 always
    ],
    "func-names": 1,                              // 函数是否一定要有名字，平时一些匿名函数也要起名字，可方便调试
    "func-name-matching": [2,                     // 函数名是否要和定义时的变量匹配上
      "always",                                   // 要求 `var foo = function foo () {}`
      {
        "includeCommonJSModuleExports": false,    // 是否限制 CommonJs 的 `modole.exports`
      },
    ],
    "func-style": [2,                             // 函数风格，使用函数定义，还是变量定义
      "declaration",
      {
        "allowArrowFunctions": true,              // 是否允许箭头函数
      },
    ],
    "id-blacklist": [0,                           // 变量名、函数名、参数名、对象属性名不允许使用以下单词
      "data", "err", "e", "cb", "callback",
    ],
    "id-length": [2,                              // 变量名、函数名、对象属性名的长度
      {
        "min": 1,                                 // 最小长度
        "max": 50,                                // 最大长度
        "properties": "always",                   // 是否检查对象属性名
        "exceptions": [],                         // 例外
      },
    ],
    "id-match": [0,                               // 变量、函数名、对象属性名的命名规范
      "^[A-Za-z]+([A-Z][a-z0-9]*)*$",             // 对应的正则匹配
      {
        "properties": true,                       // 是否检查对象属性名
      },
    ],
    "indent": [2,                                 // 使用何种缩进方式
      2,                                          // 以 2 个空格缩进
      {
        "SwitchCase": 1,                          // switch/case 语句是否缩进，1 指 1 个缩进，乘以前边的每个缩进 2 个空格，就是要有 2 个空格的缩进，下同
        "VariableDeclarator": {                   // 定义变量的时候如果使用逗号分隔一行一个，如何缩进
          "var": 2,
          "let": 2,
          "const": 3,
        },
        "outerIIFEBody": 1,                       // 文件级别的 IIFE 内容有几个缩进
        "MemberExpression": 1,                    // 属性的缩进
        "FunctionDeclaration": {                  // 函数的缩进
          "parameters": 1,                        // 参数，除了数字，也可以用 first，用来表示和第一个参数对齐
          "body": 1,                              // 函数体
        },
        "FunctionExpression": {                   // 函数表达式的缩进，参考上边的 FunctionDeclaration
          "parameters": 1,
          "body": 1,
        },
        "CallExpression": {                       // 函数调用时的参数
          "arguments": 1,                         // 函数调用的参数
        },
        "ArrayExpression": 1,                     // 数组多个项的缩进
        "ObjectExpression": 1,                    // 对象多个项的缩进
      },
    ],
    "jsx-quotes": [0,                             // jsx 语法倾向于使用哪一种括号
      "prefer-double",
    ],
    "key-spacing": [2,                            // 在对象的冒号前后是否要有空格
      {
        "mode": "strict",                         // 仅允许一个空格
        "beforeColon": false,                     // 在冒号前是否要空格
        "afterColon": true,                       // 在冒号后是否要空格
      },
    ],
    "keyword-spacing": [2,                        // 关键字前后的空格检查
      {
        "before": true,                           // 关键字前的空格
        "after": true,                            // 关键字后的空格
        "overrides": {                            // 以关键字为 key 的例外定义
          // "function": {
          //   "before": false
          // }
        },
      },
    ],
    "line-comment-position": [2,                  // 单行注释的位置
      {
        "position": "above",                      // 在代码的上面
        "ignorePattern": "",                      // 忽略的正则匹配
        "applyDefaultPatterns": true,             // 此检测默认忽略掉以下单词开始的注释：eslint, jshint, jslint, istanbul, global, exported, jscs, falls through，此选项用于关闭这个默认配置
      },
    ],
    "linebreak-style": [2,                        // 回车符号使用哪个版本 CR/LF
      "unix",
    ],
    "lines-around-comment": [2,                   // 定义注释前后的细节
      {
        "beforeBlockComment": true,               // 在块注释前是否空一行
        "afterBlockComment": false,               // 在块注释后是否空一行
        "beforeLineComment": false,               // 在行注释前是否空一行
        "afterLineComment": false,                // 在行注释后是否空一行
        "allowBlockStart": true,                  // 在 Block 第一行时，需要检查注释前是否有空行
        "allowBlockEnd": true,                    // 在 Block 最后一行时，是否检查注释后是否有空行
        "allowObjectStart": true,                 // 在 Object 第一行时，需要检查注释前是否有空行
        "allowObjectEnd": true,                   // 在 Object 最后一行时，是否检查注释后是否有空行
        "allowArrayStart": true,                  // 在 Array 第一行时，需要检查注释前是否有空行
        "allowArrayEnd": true,                    // 在 Array 最后一行时，是否检查注释后是否有空行
      },
    ],
    "lines-around-directive": [2,                 // 像 `use strict`, `use asm` 这样的指令前后是否需要空行
      {
        "before": "always",
        "after": "always",
      },
    ],
    "max-depth": [2,                              // 每个函数中最大可嵌套的层数
      4,
    ],
    "max-len": [1,                                // 每行的最大长度
      80,                                         // 每行 80 个字符
      4,                                          // 一个 <tab> 算 4 个字符，注意这里指的是 <tab> 字符，而不是缩进对应的空格数
      {
        "ignoreComments": true,                   // 是否检查计算注释
        "ignoreTrailingComments": true,           // 是否忽略因为结尾注释才超过限定长度
        "ignoreUrls": true,                       // 是否忽略 URL
        "ignoreStrings": true,                    // 是否忽略字符串
        "ignoreTemplateLiterals": true,           // 是否忽略模板字符串
        "ignoreRegExpLiterals": true,             // 是否忽略正则表达式
        "ignorePattern": "",                      // 要忽略的匹配，内容为正则字符串
      },
    ],
    "max-lines": [2,                              // 一个文件最多多少行
      {
        "max": 300,
        "skipBlankLines": true,                   // 跳过空白行
        "skipComments": true,                     // 跳过注释行
      },
    ],
    "max-nested-callbacks": [2,                   // 最多嵌套多少层 callback
      3,
    ],
    "max-params": [2,                             // 一个函数最多可以有多少个参数
      9,
    ],
    "max-statements": [0,                         // 一个函数中最多可以有多少条语句
      100,
    ],
    "max-statements-per-line": [2,                // 一行最多可以有多少条语句
      {
        "max": 1,
      },
    ],
    "multiline-ternary": [0,                      // 三元表达式的换行方案
      "never",                                    // 只有 never/always 可选
    ],
    "new-cap": [2,                                // 检查 new 操作符后的命名是否为大写字母开头
      {
        "newIsCap": true,                         // 检查所有首字母开头的函数都仅用 new 调用
        "capIsNew": true,                         // 检查所有 new 后跟的函数都是首字母大写的
        "newIsCapExceptions": [],                 // 对应的 newIsCap 例外
        "capIsNewExceptions": [],                 // 对应的 capIsNew 例外，默认: Array, Boolean, Date, Error, Function, Number, Object, RegExp, String, Symbol
      },
    ],
    "new-parens": 2,                              // 使用 new 操作符时，构造函数要带括号
    "newline-after-var": [0,                      // var 定义后留一个空行（最佳实践希望把定义变量与运行代码用一个空行分开）
      "always",
    ],
    "newline-before-return": 0,                   // return 语句前留一个空行
    "newline-per-chained-call": [0,               // 链式调用每行一个调用
      {
        "ignoreChainWithDepth": 3,                // 如果链式短到 N 个，可以忽略
      },
    ],
    "no-array-constructor": 2,                    // 不允许使用 Array 构造函数（允许通过数字构造某长度的数组，但不允许传入数组值的方式）
    "no-bitwise": 2,                              // 不允许使用位运算操作符
    "no-continue": 2,                             // 不允许使用 continue
    "no-inline-comments": 2,                      // 不允许在代码行最后加注释
    "no-lonely-if": 2,                            // 不允许在 else 中仅有独立的 if，可改用 else if 语句
    "no-mixed-operators": [2,                     // 不允许不同优先级的操作符混用，需要使用括号分隔
      {
        "groups": [                               // 每一组的优先级相同
          ["+", "-", "*", "/", "%", "**"],
          ["&", "|", "^", "~", "<<", ">>", ">>>"],
          ["==", "!=", "===", "!==", ">", ">=", "<", "<="],
          ["&&", "||"],
          ["in", "instanceof"],
        ],
        "allowSamePrecedence": true,              // 相同优先级的操作符是否可混用
      },
    ],
    "no-mixed-spaces-and-tabs": 2,                // 不允许在缩进中 <space> 和 <tab> 混用
    "no-multiple-empty-lines": [2,                // 不允许连续多个空行
      {
        "max": 2,
      },
    ],
    "no-negated-condition": 2,                    // 不允许在 if/else 里先用否定式
    "no-nested-ternary": 2,                       // 不允许嵌套三元运算符
    "no-new-object": 2,                           // 不允许使用构造函数声明对象，直接用字面量
    "no-plusplus": [2,                            // 不允许使用 ++/-- 操作符，用 +=/-= 代替
      {
        "allowForLoopAfterthoughts": true,        // 但允许在 for 循环的表达式中使用
      },
    ],
    "no-restricted-syntax": [0,                   // 不允许某些特殊语法
      "FunctionExpression",                       // 不允许使用表达式赋值函数 `var fn = function () {}`
      "WithStatement",                            // 不允许使用 with
    ],
    "no-tabs": 2,                                 // 在代码及注释中不允许使用 tab
    "no-ternary": 0,                              // 不允许使用三元运算符
    "no-trailing-spaces": [2,                     // 行尾不允许有空格
      {
        "skipBlankLines": false,                  // 跳过空行
      },
    ],
    "no-underscore-dangle": [0,                   // 不允许变量头尾使用下划线
      {
        "allow": [],                              // 例外列表
      },
    ],
    "no-unneeded-ternary": [2,                    // 不允许使用不必要的三元表达式，如 `a = a ? a : 1`
      {
        "defaultAssignment": false,               // 默认表达式是否可以使用此方式
      },
    ],
    "no-whitespace-before-property": 2,           // 属性 `.` 前不允许有空格 `foo. bar .baz . quz`，换行对齐不受影响
    "object-curly-newline": [0,                   // 对象的大括号内是否要换行
      {
        "ObjectExpression": "always",
        "ObjectPattern": {
          "multiline": true,                      // 只有多行表示时，需要换行
        },
      },
    ],
    "object-curly-spacing": [2,                   // 当整个对象在一行时，大括号前后是否要加空格
      "never",
      {
        "objectsInObjects": false,                // 针对嵌套对象的检测
        "arraysInObjects": false,                 // 针对嵌套数组的检测
      },
    ],
    "object-property-newline": [2,                // 是否允许对象属性在一行
      {
        "allowMultiplePropertiesPerLine": true,   // 允许所有属性在同一行，即：要么每个属性一行，要么所有属性在同一行，不允许一行多个还分多行的情况
      },
    ],
    "one-var": [2,                                // 一个函数中只有一个 var / const / let
      {
        "uninitialized": "always",                // 用于非初始化的变量，放在一个 var 里
        "initialized": "never",                   // 用于初始化的变量，每个变量一个 var
      },
    ],
    "one-var-declaration-per-line": [2,           // 每行定义一个变量
      "initializations",                          // 如果对变量赋值时才执行检查
    ],
    "operator-assignment": [2,                    // 缩短操作符，对于 += 等情况，推荐用 `x += y` 还是 `x = x + y`
      "always",
    ],
    "operator-linebreak": [2,                     // 操作符前后有换行时，操作符应该在前一行首，还是下一行尾
      "before",
      {
        "overrides": {                            // 需要特殊处理的 case
          "?": "before",
          "+=": "none",
        },
      },
    ],
    "padded-blocks": [2,                          // 在语句块前后是否需要一个空行分隔
      "never",
    ],
    "quote-props": [2,                            // 对象的属性是否需要括号
      "as-needed",                                // 只在需要的时候加
      {
        "keywords": true,                         // 当 as-needed 时，对于 JS 关键词是否需要括号
        "numbers": true,
      },
    ],
    "quotes": [2,                                 // 字符串使用单引号还是双引号
      "single",
      "avoid-escape",
    ],
    "require-jsdoc": 0,                           // 函数是否有符合 JSDoc 格式的注释
    "semi": [2,                                   // 语句后是否要加分号
      "never",
    ],
    "semi-spacing": [2,                           // 分号前后是否要加空格
      {
        "before": false,
        "after": true,
      },
    ],
    "sort-keys": [0,                              // 对对象的 key 排序
      "asc",                                      // 正序，倒序为 'desc'
      {
        "caseSensitive": true,                    // 区分大小写
        "natural": true,                          // 按照自然数排序，如 `1, 10, 2` 还是 `1, 2, 10`
      },
    ],
    "sort-vars": [0,                              // 变量定义是否按 ASCII 排序
      {
        "ignoreCase": true,
      }
    ],
    "space-before-blocks": [2,                    // 在大括号开始前是否要加空格
      {
        "functions": "always",                    // 针对函数体大括号前
        "keywords": "always",                     // 针对关键字后的大括号前
      },
    ],
    "space-before-function-paren": [2,            // 函数后的调用括号前是否要加空格
      {
        "anonymous": "always",                    // 针对匿名函数
        "named": "always",                        // 针对具名函数
        "asyncArrow": "always",                   // 针对 async 箭头函数
      },
    ],
    "space-in-parens": [2,                        // 小括号内部是否要加空格
      "never",
      {
        "exceptions": [],                         // 可用于排除检查的 case
      },
    ],
    "space-infix-ops": [2,                        // 在中缀（二元、三元）操作符前后是否要有空格，如 +, -, *, /, >, <, =, ?:
      {
        "int32Hint": true,                        // 是否允许 `var foo = bar|0`
      },
    ],
    "space-unary-ops": [2,                        // 一元操作符前后是否允许加空格
      {
        "words": true,                            // 像 new, delete, typeof, void, yield 后需要加空格
        "nonwords": false,                        // 非单词类的一元操作符不能加空格，如 -, +, --, ++, !, !!
      },
    ],
    "spaced-comment": [1,                         // 注释最开始是否需要留空格
      "always",
      {
        "line": {                                 // 针对单行注释
          "markers": ["/"],                       // markers 表示有此 mark 则排除检查，markers 只能出现在最开始
          "exceptions": ["-", "+"],               // 注释中有以下字符出现，则排除检查
        },
        "block": {                                // 针对多行注释
          "markers": ["!"],
          "exceptions": ["*"],
        },
      },
    ],
    "unicode-bom": [2,                            // 是否允许出现 BOM
      "never",
    ],
    "wrap-regex": 2,                              // 是否要包裹正则字面量 `/reg/.test()` -> `(/reg/).test()`

    // ECMAScript 6
    "arrow-body-style": [0,                       // 箭头函数的语句是否使用大括号包裹
      "as-needed",                                // 大于一句时才需要
    ],
    "arrow-parens": [0,                           // 箭头函数参数是否一定要用括号
      "as-needed",                                // 大于一个时才需要
      {
        "requireForBlockBody": true,              // 当函数体使用 `{}` 包裹时，参数也用 `()` 包裹
      },
    ],
    "arrow-spacing": [2,                          // 箭头函数的箭头前后是否要有空格
      {
        "before": true,                           // 箭头前要有空格
        "after": true,                            // 箭头后要有空格
      },
    ],
    "constructor-super": 2,                       // 检查在继承的 class 的 constructor 里边是否有 `super()` 调用
    "generator-star-spacing": [2,                 // generator 的 * 号前后是否要有空格
      {
        "before": true,                           // * 号前有空格
        "after": false,                           // * 号后无空格
      },
    ],
    "no-class-assign": 2,                         // 不允许 class 定义的名称再被重新赋值
    "no-confusing-arrow": [2,                     // 不允许可能产生混淆的箭头函数，如 `let x = a => 1 ? 2 : 3;`
      {
        "allowParens": true,                      // 是否允许通过括号分隔，如 `let x = (a <= 1 ? 2 : 3)`
      },
    ],
    "no-const-assign": 2,                         // 不允许对 const 变量再有赋值操作
    "no-dupe-class-members": 2,                   // 不允许重复的 class 方法/属性
    "no-duplicate-imports": [2,                   // 不允许重复 import 同一个 module
      {
        "includeExports": true,                   // 包括 export 的情况
      },
    ],
    "no-new-symbol": 2,                           // 不允许使用 new 调用 Symbol，因为 Symbol 是被当作函数进行调用的
    "no-restricted-imports": [0,                  // 不允许 import 受限制的 module
      "jquery", "fs",                             // 不允许 import 这些 module
    ],
    "no-this-before-super": 2,                    // 不允许在 super 前使用 this
    "no-useless-computed-key": 2,                 // 不允许不必要的动态对象值
    "no-useless-constructor": 2,                  // 不允许不必要的 constructor，如果 constructor 什么都没干，就不需要写
    "no-useless-rename": [2,                      // 不允许不必要的重命名
      {
        "ignoreImport": false,                    // import 中是否允许，如 `import { foo as foo } from "bar";`
        "ignoreExport": false,                    // export 中是否允许，如 `export { foo as foo }`
        "ignoreDestructuring": false,             // 变量解构中是否允许，如 `let { foo: foo } = bar`
      },
    ],
    "no-var": 1,                                  // 只使用 let/const，不使用 var
    "object-shorthand": [2,                       // 更简洁的对象定义方案
      "always",                                   // 总是检查对象的属性名和值的关系
      {
        "avoidQuotes": true,                      // 不允许简写需要加引号的 key
        "ignoreConstructors": true,               // 忽略构造函数
      },
    ],
    "prefer-arrow-callback": [2,                  // 在必要时建议使用箭头函数
      {
        "allowNamedFunctions": false,             // 允许命名函数
        "allowUnboundThis": true,                 // 允许在函数中使用 this
      }
    ],
    "prefer-const": 0,                            // 如果 let 定义的变量未被修改过，提示使用 const
    "prefer-destructuring": [2,                   // 建议使用 数组/对象... 的解构语法
      {
        "array": false,                           // 数组的解构，`var [foo, bar] = array`
        "object": true,                           // 对象的解构，`var {foo, bar} = object`
      },
      {
        "enforceForRenamedProperties": false,     // 重命名对象属性名时，是否要使用解构语法，`var {foo: bar} = object` 或 `var bar = object.foo`
      },
    ],
    "prefer-numeric-literals": 2,                 // ES2015 规定了 2、8、16 进制数字的字面量表示方式，所以如果使用 parseInt 转换 2、8、16 进制数字时，给出直接使用数字字面量的提示，不建议再使用 parseInt 进行转换
    "prefer-reflect": [0,                         // 使用 Reflect 方案，而不是原来 Object 上的方法
      {
        "exceptions": [                           // 可以使用的方法
          "apply",
          "call",
          "defineProperty",
          "getOwnPropertyDescriptor",
          "getPrototypeOf",
          "setPrototypeOf",
          "isExtensible",
          "getOwnPropertyNames",
          "preventExtensions",
          "delete",
        ],
      },
    ],
    "prefer-rest-params": 2,                      // 建议使用 `...args` 来替代 arguments
    "prefer-spread": 2,                           // 建议在函数调用时使用解构方案
    "prefer-template": 2,                         // 有字符串拼接时，建议使用模板字符串
    "require-yield": 2,                           // 要求在 generator 里必须有 `yield`
    "rest-spread-spacing": [2,                    // 对象的 rest 解构与扩展运算符，与后边的表达式间是否要有空格
      "never",
    ],
    "sort-imports": [0,                           // import 时的顺序
      {
        "ignoreCase": true,                       // 忽略大小写
        "ignoreMemberSort": false,                // 忽略解构时每一项的排序
        "memberSyntaxSortOrder": [                // 具体的排序规则
          "none", "all", "multiple", "single",
        ],
      },
    ],
    "symbol-description": 2,                      // Symbol 需要描述，如 `let foo = Symbol('some description')`
    "template-curly-spacing": [2,                 // 模板字符串表达式与大括号间是否要有空格，`${exp}` 或 `${ exp }`
      "never",
    ],
    "yield-star-spacing": [2,                     // yield 的 * 号前后是否要有空格，参考 'generator-star-spacing'
      {
        "before": true,                           // * 号前有空格
        "after": false,                           // * 号后无空格
      },
    ],
  },
}
