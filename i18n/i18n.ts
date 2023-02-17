/* eslint-disable */
import {
  makeGenericClientConstructor,
  ChannelCredentials,
  ChannelOptions,
  UntypedServiceImplementation,
  handleUnaryCall,
  Client,
  ClientUnaryCall,
  Metadata,
  CallOptions,
  ServiceError,
} from "@grpc/grpc-js";
import _m0 from "protobufjs/minimal.js";

export const protobufPackage = "";

export interface Translate {
  src?: string | undefined;
  to: string;
  li: string[];
}

export interface TranslateA {
  li: string[];
}

function createBaseTranslate(): Translate {
  return { src: undefined, to: "", li: [] };
}

export const Translate = {
  encode(
    message: Translate,
    writer: _m0.Writer = _m0.Writer.create()
  ): _m0.Writer {
    if (message.src !== undefined) {
      writer.uint32(10).string(message.src);
    }
    if (message.to !== "") {
      writer.uint32(18).string(message.to);
    }
    for (const v of message.li) {
      writer.uint32(26).string(v!);
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): Translate {
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

function createBaseTranslateA(): TranslateA {
  return { li: [] };
}

export const TranslateA = {
  encode(
    message: TranslateA,
    writer: _m0.Writer = _m0.Writer.create()
  ): _m0.Writer {
    for (const v of message.li) {
      writer.uint32(10).string(v!);
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): TranslateA {
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

export type I18nService = typeof I18nService;
export const I18nService = {
  translate: {
    path: "/I18n/translate",
    requestStream: false,
    responseStream: false,
    requestSerialize: (value: Translate) =>
      Buffer.from(Translate.encode(value).finish()),
    requestDeserialize: (value: Buffer) => Translate.decode(value),
    responseSerialize: (value: TranslateA) =>
      Buffer.from(TranslateA.encode(value).finish()),
    responseDeserialize: (value: Buffer) => TranslateA.decode(value),
  },
} as const;

export interface I18nServer extends UntypedServiceImplementation {
  translate: handleUnaryCall<Translate, TranslateA>;
}

export interface I18nClient extends Client {
  translate(
    request: Translate,
    callback: (error: ServiceError | null, response: TranslateA) => void
  ): ClientUnaryCall;
  translate(
    request: Translate,
    metadata: Metadata,
    callback: (error: ServiceError | null, response: TranslateA) => void
  ): ClientUnaryCall;
  translate(
    request: Translate,
    metadata: Metadata,
    options: Partial<CallOptions>,
    callback: (error: ServiceError | null, response: TranslateA) => void
  ): ClientUnaryCall;
}

export const I18nClient = makeGenericClientConstructor(
  I18nService,
  "I18n"
) as unknown as {
  new (
    address: string,
    credentials: ChannelCredentials,
    options?: Partial<ChannelOptions>
  ): I18nClient;
  service: typeof I18nService;
};
