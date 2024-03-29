using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Sitecore.Diagnostics;
using Sitecore.Rules;
using Sitecore.Rules.Conditions;

namespace Sample.Foundation.Common.SitcoreCustomRule
{
    public class QueryStringNameValueCustomRule<T> : StringOperatorCondition<T> where T : RuleContext
    {
        public string querystringname { get; set; }
        public string querystringvalue { get; set; }

        protected override bool Execute(T ruleContext)
        {
            bool isPersonalized = false;
            Assert.ArgumentNotNull(ruleContext, "ruleContext");
            var queryStringNameFromRule = this.querystringname; //QS NAME
            var queryStringValueFromRule = this.querystringvalue; //QS VALUE

            if (string.IsNullOrWhiteSpace(queryStringNameFromRule) || string.IsNullOrWhiteSpace(queryStringValueFromRule))
                return isPersonalized;

            if(string.IsNullOrWhiteSpace(HttpContext.Current.Request.QueryString[queryStringNameFromRule]))
                return isPersonalized;

            var queryStringValueFromURL = Convert.ToString(HttpContext.Current.Request.QueryString[queryStringNameFromRule]).Trim();
            if (queryStringValueFromURL.ToLower() == queryStringValueFromRule.Trim().ToLower())
                return true;

            return isPersonalized;
        }
    }
}
