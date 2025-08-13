```
$ nix eval --file playground.nix
```

## 例

次の option のとき

```nix
{ name = lib.mkOption { type = lib.types.str; }; }
```

### config に値がないとき

```
error:
       … while evaluating the attribute 'name'

       … while evaluating the attribute 'value'
         at /nix/store/anlzc2nqv1qckrlyxd55zgmghri1356r-nixpkgs/nixpkgs/lib/modules.nix:809:9:
          808|     in warnDeprecation opt //
          809|       { value = builtins.addErrorContext "while evaluating the option `${showOption loc}':" value;
             |         ^
          810|         inherit (res.defsFinal') highestPrio;

       … while calling the 'addErrorContext' builtin
         at /nix/store/anlzc2nqv1qckrlyxd55zgmghri1356r-nixpkgs/nixpkgs/lib/modules.nix:809:17:
          808|     in warnDeprecation opt //
          809|       { value = builtins.addErrorContext "while evaluating the option `${showOption loc}':" value;
             |                 ^
          810|         inherit (res.defsFinal') highestPrio;

       (stack trace truncated; use '--show-trace' to show the full trace)

       error: The option `name' is used but not defined.
```

### 形が違うとき

```
error:
       … while evaluating the attribute 'name'

       … while evaluating the attribute 'value'
         at /nix/store/anlzc2nqv1qckrlyxd55zgmghri1356r-nixpkgs/nixpkgs/lib/modules.nix:809:9:
          808|     in warnDeprecation opt //
          809|       { value = builtins.addErrorContext "while evaluating the option `${showOption loc}':" value;
             |         ^
          810|         inherit (res.defsFinal') highestPrio;

       … while calling the 'addErrorContext' builtin
         at /nix/store/anlzc2nqv1qckrlyxd55zgmghri1356r-nixpkgs/nixpkgs/lib/modules.nix:809:17:
          808|     in warnDeprecation opt //
          809|       { value = builtins.addErrorContext "while evaluating the option `${showOption loc}':" value;
             |                 ^
          810|         inherit (res.defsFinal') highestPrio;

       (stack trace truncated; use '--show-trace' to show the full trace)

       error: A definition for option `name' is not of type `string'. Definition values:
       - In `/home/kazuki/Projects/nix-module-playground/config.nix': 1
```

### うまくいったとき

```
$ nix eval --file playground.nix
{ name = ""; }
```

### `name = ""` と `name = "John"` が与えられたとき

```
error:
       … while evaluating the attribute 'name'

       … while evaluating the attribute 'value'
         at /nix/store/anlzc2nqv1qckrlyxd55zgmghri1356r-nixpkgs/nixpkgs/lib/modules.nix:809:9:
          808|     in warnDeprecation opt //
          809|       { value = builtins.addErrorContext "while evaluating the option `${showOption loc}':" value;
             |         ^
          810|         inherit (res.defsFinal') highestPrio;

       … while calling the 'addErrorContext' builtin
         at /nix/store/anlzc2nqv1qckrlyxd55zgmghri1356r-nixpkgs/nixpkgs/lib/modules.nix:809:17:
          808|     in warnDeprecation opt //
          809|       { value = builtins.addErrorContext "while evaluating the option `${showOption loc}':" value;
             |                 ^
          810|         inherit (res.defsFinal') highestPrio;

       (stack trace truncated; use '--show-trace' to show the full trace)

       error: The option `name' has conflicting definition values:
       - In `<unknown-file>': "John"
       - In `/home/kazuki/Projects/nix-module-playground/config.nix': ""
       Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
```

次の option のとき

```nix
{ name = lib.mkOption { type = lib.types.listOf lib.types.str; }; }
```

### `name = ""` と `name = "John"` が与えられたとき

```
error:
       … while evaluating the attribute 'name'

       … while evaluating the attribute 'value'
         at /nix/store/anlzc2nqv1qckrlyxd55zgmghri1356r-nixpkgs/nixpkgs/lib/modules.nix:809:9:
          808|     in warnDeprecation opt //
          809|       { value = builtins.addErrorContext "while evaluating the option `${showOption loc}':" value;
             |         ^
          810|         inherit (res.defsFinal') highestPrio;

       … while calling the 'addErrorContext' builtin
         at /nix/store/anlzc2nqv1qckrlyxd55zgmghri1356r-nixpkgs/nixpkgs/lib/modules.nix:809:17:
          808|     in warnDeprecation opt //
          809|       { value = builtins.addErrorContext "while evaluating the option `${showOption loc}':" value;
             |                 ^
          810|         inherit (res.defsFinal') highestPrio;

       (stack trace truncated; use '--show-trace' to show the full trace)

       error: A definition for option `name' is not of type `list of string'. Definition values:
       - In `<unknown-file>': "John"
       - In `/home/kazuki/Projects/nix-module-playground/config.nix': ""
```

### `name = ["Abe"]` と `name = ["John"]` が与えられたとき

`++` で結合される

```
{ name = [ "John" "Abe" ]; }
```

次の option のとき

```nix
{ name = lib.mkOption { type = lib.types.attrs; }; }
```

`lib.types` はここで定義されている

https://github.com/NixOS/nixpkgs/blob/master/lib/types.nix

### `name = { a = "A"; }` と `name = { b = "B"; }` が与えられたとき

キーがかぶらないなら両方のキーと値が含まれる

```
{ name = { a = "A"; b = "B"; }; }
```

### `name = { a = "A"; }` と `name = { a = "B"; }` が与えられたとき

キーがかぶると先勝ち

```
{ name = { a = "A"; }; }
```

### `{ a = [ "A" ]; }` と `{ a = [ "B" ]; }` が与えられたとき

`lib.types.attrs` のときは再帰的にマージされない

```
{ name = { a = "A"; }; }
```

次の option のとき

```nix
{
  options = {
    a = lib.mkOption { type = lib.types.submodule {
      options = {
        aa = lib.mkOption { type = lib.types.str; };
        ab = lib.mkOption { type = lib.types.int; };
      };
    }; };
  };
}
```

### `a = { aa = "A"; }` と `a = { ab = 1; }` が与えられたとき

`a` はマージされる

```
{ a = { aa = "A"; ab = 1; }; }
```
