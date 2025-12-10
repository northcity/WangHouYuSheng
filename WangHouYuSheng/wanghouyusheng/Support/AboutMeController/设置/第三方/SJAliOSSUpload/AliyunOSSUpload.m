//
//  AliyunOSSUpload.m
//  HuaYin
//
//  Created by 陈希 on 2020/7/30.
//  Copyright © 2020 陈希. All rights reserved.
//

#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>
#import "AliyunOSSUpload.h"
//#import "NSObject+SBJSON.h"
#import "WHYSManager.h"


OSSClient * client;

///阿里云OSS配置
#define AccessKeyId  @""
#define AccessKeySecret @""
#define OSS_Bucket @"lajifenleipic"
#define OSS_endpoint  @"oss-cn-shanghai.aliyuncs.com"
#define Yu_Ming @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/"
#define Yu_Ming_HTTP @"http:lajifenleipic.oss-cn-shanghai.aliyuncs.com/"

#define TouXiang_URL @"timepills/"
#define PostPicture_URL @"postpicture/"

#define PostMp3_URL @"postmp3/"



@implementation AliyunOSSUpload

static AliyunOSSUpload *_config;

+(AliyunOSSUpload *)aliyunInit{
    @synchronized(self){
        if (_config==nil) {
            [OSSLog enableLog];
            _config=[[AliyunOSSUpload alloc] init];
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:AccessKeyId secretKeyId:AccessKeySecret securityToken:@""];
            client = [[OSSClient alloc] initWithEndpoint:OSS_endpoint credentialProvider:credential];
        }
    }
    return _config;
}



//-(void)uploadImage:(NSArray*)imgArr imagesObject:(NSArray *)imagesObject success:(void (^)(NSString *obj))success{
//    NSMutableArray *imgArray=[NSMutableArray new];
//    for (int i=0; i<imgArr.count; i++) {
//        NSData* data;
//
//        UIImage *image1 = (UIImage *)imgArr[i];
//        UIImage *image=[IHUtility rotateAndScaleImage:image1 maxResolution:(int)ScreenWidth*2];
//        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
//        put.contentType=@"image/jpeg";
//        put.bucketName = @"跟后台要";
//        NSString *imgName;
//            NSData *data1=UIImageJPEGRepresentation(image, 1);
//            float length1 = [data1 length]/1024;
//            if (length1<600) {
//                data = UIImageJPEGRepresentation(image, 1);
//            }else{
//                data = UIImageJPEGRepresentation(image, 0.5);
//            }
//              //保证和服务器的文件名字一样
//              imgName = imagesObject[i];
//        put.objectKey = imgName;
//        put.uploadingData = data; // 直接上传NSData
//
//        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//            NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
//        };
//
//        NSString *imgWidth;
//        NSString *imgHeigh;
//            imgWidth=[NSString stringWithFormat:@"%lf",image.size.width];
//            imgHeigh=[NSString stringWithFormat:@"%lf",image.size.height];
//        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"/%@",imgName],@"t_url",
//                           imgWidth,@"t_width",
//                           imgHeigh,@"t_height",
//                           nil];
//        [imgArray addObject:dic];
//
//        if (client==nil) {
//            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:@"服务器获取" secretKeyId:@"服务器获取" securityToken:@"服务器获取"];
//
//            client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential];
//        }
//
//        OSSTask * putTask = [client putObject:put];
//
//        [putTask continueWithBlock:^id(OSSTask *task) {
//            if (!task.error) {
//                NSLog(@"upload object success!");
//                 if (type==ENT_fileImageProject){
//                    if (i==imgArr.count-1) {
//                        NSString *str=[imgArray JSONRepresentation];
//                        success(str);
//                    }
//                }
//
//            } else{
//                NSLog(@"upload object failed, error: %@" , task.error);
//                [SVProgressHUD showErrorWithStatus:@"图片上传失败！"];
//            }
//            return nil;
//        }];
//    }
//}

//上传单张图片
- (void)upLoadImage:(NSArray *)imageArr success:(UploadSuccessBlock) successBlock{
    UIImage *selImage = imageArr[0];
    NSData *data = UIImageJPEGRepresentation(selImage, 1);
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = OSS_Bucket;//后台返回的
    //根据用户ID和时间戳来生成一段字符串 来保证图片的唯一性
    NSString *timestr = [NSString stringWithFormat:@"%@",[WHYSManager getCurrentTimeToSecond]];
    //将后台返回的uploadFilePath和上面的字符串拼接在一起
    put.objectKey = [NSString stringWithFormat:@"%@%@.jpg",PostPicture_URL,timestr];
    put.uploadingData = data; // 直接上传NSData
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
            
    };

    OSSTask * putTask = [client putObject:put];
   
    [putTask continueWithBlock:^id(OSSTask *task) {
    //缺少的就是这一步   里面的参数和上面一样
          task = [client presignPublicURLWithBucketName:OSS_Bucket
                                               withObjectKey:[NSString stringWithFormat:@"%@%@.jpg",PostPicture_URL,timestr]];

                if (!task.error) {
    //上传成功了,把图片URL地址传出去  task.result就是图片URL   传给自己服务器就好了
                    if (successBlock) {
                        successBlock(task.result,put.objectKey);
                    }
                } else {
                    NSLog(@"upload object failed, error: %@" , task.error);
//                    [SVProgressHUD showErrorWithStatus:@"图片上传失败！"];
                }
                return nil;
            }];
}

//上传多张图片
- (void)upLoadImages:(NSArray *)imageArr success:(UploadImageArrsSuccessBlock) successBlock{
   
    NSMutableArray *upLoadImageArrs = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<imageArr.count ; i++) {
        
        UIImage *selImage = imageArr[i];
           NSData *data = UIImageJPEGRepresentation(selImage, 1);
           
           OSSPutObjectRequest * put = [OSSPutObjectRequest new];
           put.bucketName = OSS_Bucket;//后台返回的
           //根据用户ID和时间戳来生成一段字符串 来保证图片的唯一性
           NSString *timestr = [NSString stringWithFormat:@"%@",[WHYSManager getCurrentTimeToHaoMiao]];
           //将后台返回的uploadFilePath和上面的字符串拼接在一起
           put.objectKey = [NSString stringWithFormat:@"%@%@.jpg",PostPicture_URL,timestr];
           put.uploadingData = data; // 直接上传NSData
           put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                       NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
                   
           };
        
        [upLoadImageArrs addObject:put.objectKey];
        
           OSSTask * putTask = [client putObject:put];
          
           [putTask continueWithBlock:^id(OSSTask *task) {
           //缺少的就是这一步   里面的参数和上面一样
                 task = [client presignPublicURLWithBucketName:OSS_Bucket
                                                      withObjectKey:[NSString stringWithFormat:@"%@%@.jpg",PostPicture_URL,timestr]];

                       if (!task.error) {
           //上传成功了,把图片URL地址传出去  task.result就是图片URL   传给自己服务器就好了
                          
                           if (i == imageArr.count - 1) {
                         
                                                        if (successBlock) {
                                                            successBlock(task.result,upLoadImageArrs);
                                                        }
//                               [SVProgressHUD showSuccessWithStatus:@"多张图片上传成功！，地址已返回"];

                           }
                         
                           
                           
                       } else {
                           NSLog(@"upload object failed, error: %@" , task.error);
//                           [SVProgressHUD showErrorWithStatus:@"图片上传失败！"];
                       }
                       return nil;
                   }];
        
    }
}
































- (void)upLoadFile:(NSString *)outMp3path success:(UploadSuccessBlock) successBlock{

     NSData *wavDATA = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:outMp3path]];

       OSSPutObjectRequest * put = [OSSPutObjectRequest new];
       put.bucketName = OSS_Bucket;//后台返回的
       //根据用户ID和时间戳来生成一段字符串 来保证图片的唯一性
       NSString *timestr = [NSString stringWithFormat:@"%@%@",@"username",[WHYSManager getCurrentTimeToHaoMiao]];
       //将后台返回的uploadFilePath和上面的字符串拼接在一起
       put.objectKey = [NSString stringWithFormat:@"%@%@.mp3",PostMp3_URL,timestr];
       put.uploadingData = wavDATA; // 直接上传NSData
       put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                   NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);

       };

       OSSTask * putTask = [client putObject:put];

       [putTask continueWithBlock:^id(OSSTask *task) {
       //缺少的就是这一步   里面的参数和上面一样
             task = [client presignPublicURLWithBucketName:OSS_Bucket
                                                  withObjectKey:[NSString stringWithFormat:@"%@%@.mp3",PostMp3_URL,timestr]];

                   if (!task.error) {
       //上传成功了,把图片URL地址传出去  task.result就是图片URL   传给自己服务器就好了
                       if (successBlock) {
                           successBlock(task.result,put.objectKey);
                       }
                   } else {
                       NSLog(@"upload object failed, error: %@" , task.error);
//                       [SVProgressHUD showErrorWithStatus:@"图片上传失败！"];
                   }
                   return nil;
               }];

}
//
//
//- (void)upLoadFilesuccess:(UploadSuccessBlock) successBlock{
//
//    NSURL* url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sucai4" ofType:@"mp3"]];
//
//     NSData *wavDATA = [NSData dataWithContentsOfURL:url];
//
//       OSSPutObjectRequest * put = [OSSPutObjectRequest new];
//       put.bucketName = OSS_Bucket;//后台返回的
//       //根据用户ID和时间戳来生成一段字符串 来保证图片的唯一性
//       NSString *timestr = [NSString stringWithFormat:@"%@%@",[SJUserModelManager shareInstance].user.ty_id,[SJManager getCurrentTimeToSecond]];
//       //将后台返回的uploadFilePath和上面的字符串拼接在一起
//       put.objectKey = [NSString stringWithFormat:@"%@%@.mp3",PostMp3_URL,timestr];
//       put.uploadingData = wavDATA; // 直接上传NSData
//       put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//                   NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
//
//       };
//
//       OSSTask * putTask = [client putObject:put];
//
//       [putTask continueWithBlock:^id(OSSTask *task) {
//       //缺少的就是这一步   里面的参数和上面一样
//             task = [client presignPublicURLWithBucketName:OSS_Bucket
//                                                  withObjectKey:[NSString stringWithFormat:@"%@%@.mp3",PostMp3_URL,timestr]];
//
//                   if (!task.error) {
//       //上传成功了,把图片URL地址传出去  task.result就是图片URL   传给自己服务器就好了
//                       if (successBlock) {
//                           successBlock(task.result,put.objectKey);
//                       }
//                   } else {
//                       NSLog(@"upload object failed, error: %@" , task.error);
////                       [SVProgressHUD showErrorWithStatus:@"图片上传失败！"];
//                   }
//                   return nil;
//               }];
//
//}
//









@end
