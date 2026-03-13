(function(Scratch) {
  'use strict';

  class PasteReader {
    constructor() {
      this.cache = {};
    }

    getInfo() {
      return {
        id: 'pastereader',
        name: 'Paste Reader',
        blocks: [
          {
            opcode: 'fetchPaste',
            blockType: Scratch.BlockType.COMMAND,
            text: 'load paste from [URL]',
            arguments: {
              URL: {
                type: Scratch.ArgumentType.STRING,
                defaultValue: 'https://pihub.coati-gila.ts.net/raw/paste/codednex/plworddb'
              }
            }
          },
          {
            opcode: 'getLine',
            blockType: Scratch.BlockType.REPORTER,
            text: 'line [NUM] from paste',
            arguments: {
              NUM: {
                type: Scratch.ArgumentType.NUMBER,
                defaultValue: 1
              }
            }
          },
          {
            opcode: 'lineCount',
            blockType: Scratch.BlockType.REPORTER,
            text: 'paste line count'
          }
        ]
      };
    }

    async fetchPaste(args) {
      const url = args.URL;

      const res = await fetch(url);
      const text = await res.text();

      this.cache.lines = text.split(/\r?\n/);
    }

    getLine(args) {
      if (!this.cache.lines) return '';
      const i = Math.floor(args.NUM) - 1;
      return this.cache.lines[i] || '';
    }

    lineCount() {
      if (!this.cache.lines) return 0;
      return this.cache.lines.length;
    }
  }

  Scratch.extensions.register(new PasteReader());

})(Scratch);
