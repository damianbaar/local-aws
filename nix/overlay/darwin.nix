self: super:
with super;
{ 
  darwin_env = {
    pkgs = [] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      Cocoa
      CoreServices
    ]);
  };
}
