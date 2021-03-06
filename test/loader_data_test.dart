// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn("vm")

import "dart:convert";

import "package:resource/resource.dart";
import "package:test/test.dart";

const content = "Rødgrød med fløde";

main() {
  testFile(Encoding encoding, bool base64) {
    group("${encoding.name}${base64 ? " base64" : ""}", () {
      var uri;
      setUp(() {
        var dataUri =
            new UriData.fromString(content, encoding: encoding, base64: base64);
        uri = dataUri.uri;
      });

      test("read string", () async {
        var loader = ResourceLoader.defaultLoader;
        String string = await loader.readAsString(uri, encoding: encoding);
        expect(string, content);
      });

      test("read bytes", () async {
        var loader = ResourceLoader.defaultLoader;
        List<int> bytes = await loader.readAsBytes(uri);
        expect(bytes, encoding.encode(content));
      });

      test("read byte stream", () async {
        var loader = ResourceLoader.defaultLoader;
        var bytes = loader.openRead(uri);
        var buffer = [];
        await bytes.forEach(buffer.addAll);
        expect(buffer, encoding.encode(content));
      });
    });
  }

  testFile(LATIN1, true);
  testFile(LATIN1, false);
  testFile(UTF8, true);
  testFile(UTF8, false);
}
