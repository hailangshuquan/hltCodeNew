 

#import "CallJsClass.h"
#import <UIKit/UIKit.h>
 #import <JavaScriptCore/JavaScriptCore.h>
@implementation CallJsClass{
    
    WKWebView* _webView;
    
      UIWebView* sysWebview;
    
     synCallSuccessBlock _synSuccBlock;
     asynCallSuccessBlock _aSynSuccBlock;
     callFailBlock _failBlock;
     NSString* _function;
    UIView* cunView;
}

static CallJsClass * instance=nil;
+(instancetype)OCCallJs{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[CallJsClass alloc] init];
    });
    
    return instance;
}
+(instancetype)createJsObject{
    
    return [[self alloc] init];
}

-(void)ExecuFun:(NSString*)function backResultBlock:(synCallSuccessBlock)succBlock backFailBlock:(callFailBlock)failBlock currentViewFun:(UIView*)curentView{
    
    _synSuccBlock = succBlock;
    _failBlock = failBlock;
    _function = function;
    cunView = curentView;
   
    [self loadWebView:BTC];
}

-(void)ExecuFun:(NSString*)function backResultBlock:(synCallSuccessBlock)succBlock backFailBlock:(callFailBlock)failBlock backAsynResultBlock:(asynCallSuccessBlock)asynResult currentViewFun:(UIView*)curentView{
     cunView = curentView;
    _synSuccBlock = succBlock;
    _failBlock = failBlock;
    _aSynSuccBlock = asynResult;
    
      _function = function;
     [self loadWebView:BTC];
    
}



-(void)getAddressExecuFun:(NSString*)function backResultBlock:(synCallSuccessBlock)succBlock backFailBlock:(callFailBlock)failBlock currencyName:(currencyType)cName currentViewFun:(UIView*)curentView{
    
    _synSuccBlock = succBlock;
    _failBlock = failBlock;
    _function = function;
    cunView = curentView;
    
   
    if(sysWebview == nil){
        
        UIWebView* webView = [UIWebView new];
        sysWebview  =webView;
        webView.frame = CGRectMake(0, 0,0, 0);
        [self addSubview:_webView];
        [cunView addSubview:self];
        webView.delegate =self;
    }
    
    if(cName == Bck){
        NSURL*url = [[NSBundle mainBundle] URLForResource:@"getaddress.html" withExtension:nil];
        NSURLRequest*request = [NSURLRequest requestWithURL:url];
        [sysWebview loadRequest:request];
    }else if(cName == GIT){
        NSURL*url = [[NSBundle mainBundle] URLForResource:@"getaddress.html" withExtension:nil];
        NSURLRequest*request = [NSURLRequest requestWithURL:url];
        [sysWebview loadRequest:request];
    } else{
        NSURL*url = [[NSBundle mainBundle] URLForResource:@"getaddress.html" withExtension:nil];
           NSURLRequest*request = [NSURLRequest requestWithURL:url];
           [sysWebview loadRequest:request];
        
    }
    
   
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    
      NSString* abc =  [webView stringByEvaluatingJavaScriptFromString:_function];
    
         self->_synSuccBlock(abc);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self->_failBlock(error);
}


-(void)ExecuFun:(NSString*)function backResultBlock:(synCallSuccessBlock)succBlock backFailBlock:(callFailBlock)failBlock currencyName:(currencyType)cName currentViewFun:(UIView*)curentView{
    
    _synSuccBlock = succBlock;
    _failBlock = failBlock;
    _function = function;
    cunView = curentView;
    
    [self loadWebView:cName];
}

-(void)ExecuFun:(NSString*)function backResultBlock:(synCallSuccessBlock)succBlock backFailBlock:(callFailBlock)failBlock backAsynResultBlock:(asynCallSuccessBlock)asynResult currencyName:(currencyType)cName currentViewFun:(UIView*)curentView{
    cunView = curentView;
    _synSuccBlock = succBlock;
    _failBlock = failBlock;
    _aSynSuccBlock = asynResult;
    
    _function = function;
     [self loadWebView:cName];
    
}


- (WKWebView *)loadWebView:(currencyType)type{
    if (!_webView) {
        
        WKWebViewConfiguration *wkConfig =[[WKWebViewConfiguration alloc]init];
          
        wkConfig.preferences.javaScriptEnabled = YES;
        wkConfig.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) configuration:wkConfig];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
       // NSURL *baseURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]];
        [self addSubview:_webView];
        [cunView addSubview:self];
    }
    
    NSString*  htmlName = @"getaddress";
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:htmlName ofType:@"html"];
    
   
    UIWebView* webView = [UIWebView new];
          sysWebview  =webView;
          webView.frame = CGRectMake(0, 0,0, 0);
          [self addSubview:_webView];
          [cunView addSubview:self];
          webView.delegate =self;
      
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseURL];
      [webView loadRequest:request];
    return nil;
    
}

-(void)dealloc{
    
    
}

 
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
 
    if(_aSynSuccBlock)
        _aSynSuccBlock([message.body objectForKey:@"body"]);
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
   
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
   
    if(_function==nil || _failBlock==nil || _synSuccBlock==nil)return;
    
   
    [webView evaluateJavaScript:_function completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        if(!error){
               self->_synSuccBlock(item);
            
        }else{
            self->_failBlock(error);
        }
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
   
      self->_failBlock(error);
}



@end
