---
layout: container
title: Legal notice
permalink: /legalnotice/
---
# Legal Notice

Information in accordance with § 5 Telemedia Act (TMG)

**Person responsible for content in accordance with § 55 Abs. 2 RStV**

Frank Steiler \\
Metztrasse 27 \\
70190 Stuttgart \\
Phone: 0049 151-12496081 \\
E-Mail: [{{ site.data.about.frank.contact.photo.email_desc }}](mailto:{{ site.data.about.frank.contact.photo.email }}) \\
Web address: [steilerPhoto.de](https://steilerphoto.de)

## Disclaimer:

**Accountability for content**

The contents of our pages have been created with the utmost care. However, we cannot guarantee the contents' accuracy, completeness or topicality. According to statutory provisions (§ 7 Abs. 1 TMG), we are furthermore responsible for our own content on these web pages. In this context, please note that we are accordingly not obliged to monitor merely the transmitted or saved information of third parties, or investigate circumstances pointing to illegal activity. Our obligations to remove or block the use of information under generally applicable laws remain unaffected by this as per §§ 8 to 10 of the Telemedia Act (TMG). An accountability is only possible after the notice of the violation of the law. After the infringement became known to the public we are going to delete the content immediately.

**Accountability for links**

Responsibility for the content of external links (to web pages of third parties) lies solely with the operators of the linked pages. The linked pages were checked for infringement before they were used as linked content. No violations were evident to us at the time of linking. A permanent contentwise check of these pages without any sign of legal violation is unreasonable. Should any legal infringement become known to us, we will remove the respective link immediately.

**Copyright**

Excpt where otherwise noted the content created by the owner of this webpage is licensed under the Creative Commons - Attribution - Non Commercial - Share Alike - 4.0 International License. You are free to share, copy and redistribute the material in any medium or format as well as adapt, remix, transform, and build upon the material. The licensor cannot revoke these freedoms as long as you comply with the following license terms. You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use. You may not use the material for commercial purposes. If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original. You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits. You do not have to comply with the license for elements of the material in the public domain or where your use is permitted by an applicable exception or limitation. No warranties are given. The license may not give you all of the permissions necessary for your intended use. For example, other rights such as publicity, privacy, or moral rights may limit how you use the material. The full license can be retrieved [here](http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode).

## Privacy Statement

**General**

The usage of this webpage is normally possible without the need to provide personal data. If we have to process your personal data (e.g. title, name, house address, e-mail address, phone number, bank details, credit card number), this data is processed by us only in accordance with the provisions of German data privacy laws. The following provisions describe the type, scope and purpose of collecting, processing and utilizing personal data. This data privacy policy applies only to our web pages. If links on our pages route you to other pages, please inquire there about how your data are handled in such cases.

**Inventory data**

1. Your personal data, insofar as these are necessary for this contractual relationship (inventory data) in terms of its establishment, organization of content and modifications, are used exclusively for fulfilling the contract. For goods to be delivered, for instance, your name and address must be relayed to the supplier of the goods.
2. Without your explicit consent or a legal basis, your personal data are not passed on to third parties outside the scope of fulfilling this contract. After completion of the contract, your data are blocked against further use. After expiry of deadlines as per tax-related and commercial regulations, these data are deleted unless you have expressly consented to their further use.

**Information about cookies**

1. To optimize our web presence, we use cookies. These are small text files stored in your computer's main memory. These cookies are deleted after you close the browser. Other cookies remain on your computer (long-term cookies) and permit its recognition on your next visit. This allows us to improve your access to our site.<br>
2. You can prevent storage of cookies by choosing a "disable cookies" option in your browser settings. But this can limit the functionality of our Internet offers as a result.

**Additional privacy related information**

1. We point out that the communictaion over the Internet may be exposed to security vulnerabilities. It is therefore impossible to protect your data from unauthorized access of a third party.
2. The usage of the private contact data released within this legal notice by a third party, especially to send advertising material or any other information, without any explicit request is hereby revoked.

**Disclosure**

According to the Federal Data Protection Act, you have a right to receive information about your stored data, and possibly entitlement to correction, blocking or deletion of such data free-of-charge. Inquiries can be directed to the following E-mail addresse: [{{ site.data.about.hostmaster.contact.email_desc }}](mailto:{{ site.data.about.hostmaster.contact.email }})

## Website Tracking
This web site uses Piwik, an open-source software for statistical analyses of user accesses. This software uses cookies to track and analyze your usage of this website. The collected data includes but is not limited to your IP address. This data is never sent to other servers or shared with a third party. Piwik is used to improve our services. By using this web site, you agree that the data Piwik collects about you may be processed for the purpose previously stated.

**If you do not wish to be tracked you can view and change your [tracking settings here](#tracking){:role="button"}{:data-toggle="modal"}.**
{: style="text-align: center"}

<!-- Tracking settings modal -->
<div class="modal fade" id="tracking" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
            <div class="modal-content">
            <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                        <h4 class="modal-title" id="myModalLabel">Tracking settings</h4>
                </div>
                <div class="modal-body">
                    <iframe style="border: 0; height: 100%; width: 100%;" src="{{ site.data.global.piwik.url }}/index.php?module=CustomOptOut&action=optOut&idSite={{ site.data.global.piwik.site-id }}&language=en"></iframe>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
    </div>
</div>

## Attributions

The following technologies and intelectual properties are used on this page:

{% for attribution in site.data.attributions.attributions %} 
* [{{ attribution.name }}]({{ attribution.link }}) {% if attribution.author %} by **{{ attribution.author }}** {% endif %} {% if attribution.license %} licensed under a [{{ attribution.license }}]({{ attribution.license_link }}) {% endif %} {% endfor %}
* Pictures used on the [about page]({% asset_path about.jpg %}), [first post page]({% post_url 2014-08-06-here_i_am %}), as well as the [cover picture]({% asset_path index_header_med.jpg %}) were provided by [Alexander Gehret](http://www.lanzone.eu) free of charge
* Support at creating this page by [{{ site.data.about.tammo.name }}]({{ site.data.about.tammo.github }}) ([contact via mail](mailto:{{ site.data.about.tammo.contact.email }}))
