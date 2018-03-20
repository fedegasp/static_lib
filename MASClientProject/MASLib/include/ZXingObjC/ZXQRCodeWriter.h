/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "common/ZXBitMatrix.h"
#import "core/ZXImage.h"
#import "core/ZXEncodeHints.h"
#import "qrcode/ZXQRCodeErrorCorrectionLevel.h"

/**
 * This object renders a QR Code as a BitMatrix 2D array of greyscale values.
 */
@interface ZXQRCodeWriter : NSObject

/**
 * Encode a barcode using the default settings.
 *
 * @param contents The contents to encode in the barcode
 * @param width The preferred width in pixels
 * @param height The preferred height in pixels
 */
- (ZXBitMatrix *)encode:(NSString *)contents width:(int)width height:(int)height error:(NSError **)error;

/**
 *
 * @param contents The contents to encode in the barcode
 * @param width The preferred width in pixels
 * @param height The preferred height in pixels
 * @param hints Additional parameters to supply to the encoder
 */
- (ZXBitMatrix *)encode:(NSString *)contents width:(int)width height:(int)height hints:(ZXEncodeHints *)hints error:(NSError **)error;


@end
