/* eslint-disable */
import { makeGenericClientConstructor } from "@grpc/grpc-js";
import _m0 from "protobufjs/minimal.js";
export const protobufPackage = "";
function createBaseTranslate() {
	return { src: undefined, to: "", li: [] };
}
export const Translate = {
	encode(message, writer = _m0.Writer.create()) {
		if (message.src !== undefined) {
			writer.uint32(10).string(message.src);
		}
		if (message.to !== "") {
			writer.uint32(18).string(message.to);
		}
		for (const v of message.li) {
			writer.uint32(26).string(v);
		}
		return writer;
	},
	decode(input, length) {
		const reader = input instanceof _m0.Reader ? input : new _m0.Reader(input);
		let end = length === undefined ? reader.len : reader.pos + length;
		const message = createBaseTranslate();
		while (reader.pos < end) {
			const tag = reader.uint32();
			switch (tag >>> 3) {
				case 1:
					message.src = reader.string();
					break;
				case 2:
					message.to = reader.string();
					break;
				case 3:
					message.li.push(reader.string());
					break;
				default:
					reader.skipType(tag & 7);
					break;
			}
		}
		return message;
	},
};
function createBaseTranslateA() {
	return { li: [] };
}
export const TranslateA = {
	encode(message, writer = _m0.Writer.create()) {
		for (const v of message.li) {
			writer.uint32(10).string(v);
		}
		return writer;
	},
	decode(input, length) {
		const reader = input instanceof _m0.Reader ? input : new _m0.Reader(input);
		let end = length === undefined ? reader.len : reader.pos + length;
		const message = createBaseTranslateA();
		while (reader.pos < end) {
			const tag = reader.uint32();
			switch (tag >>> 3) {
				case 1:
					message.li.push(reader.string());
					break;
				default:
					reader.skipType(tag & 7);
					break;
			}
		}
		return message;
	},
};
export const I18nService = {
	translate: {
		path: "/I18n/translate",
		requestStream: false,
		responseStream: false,
		requestSerialize: (value) => Buffer.from(Translate.encode(value).finish()),
		requestDeserialize: (value) => Translate.decode(value),
		responseSerialize: (value) => Buffer.from(TranslateA.encode(value).finish()),
		responseDeserialize: (value) => TranslateA.decode(value),
	},
};
export const I18nClient = makeGenericClientConstructor(I18nService, "I18n");
//# sourceMappingURL=i18n.js.map
