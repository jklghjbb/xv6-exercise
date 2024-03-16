
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	c7010113          	addi	sp,sp,-912 # 80019c70 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	728050ef          	jal	ra,8000573e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	d4078793          	addi	a5,a5,-704 # 80021d70 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8b090913          	addi	s2,s2,-1872 # 80008900 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	0d0080e7          	jalr	208(ra) # 8000612a <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	170080e7          	jalr	368(ra) # 800061de <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	b64080e7          	jalr	-1180(ra) # 80005bee <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	81450513          	addi	a0,a0,-2028 # 80008900 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	fa6080e7          	jalr	-90(ra) # 8000609a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	c7050513          	addi	a0,a0,-912 # 80021d70 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00008497          	auipc	s1,0x8
    80000126:	7de48493          	addi	s1,s1,2014 # 80008900 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	ffe080e7          	jalr	-2(ra) # 8000612a <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	7c650513          	addi	a0,a0,1990 # 80008900 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	09a080e7          	jalr	154(ra) # 800061de <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	79a50513          	addi	a0,a0,1946 # 80008900 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	070080e7          	jalr	112(ra) # 800061de <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ca19                	beqz	a2,80000194 <memset+0x1c>
    80000180:	87aa                	mv	a5,a0
    80000182:	1602                	slli	a2,a2,0x20
    80000184:	9201                	srli	a2,a2,0x20
    80000186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018e:	0785                	addi	a5,a5,1
    80000190:	fee79de3          	bne	a5,a4,8000018a <memset+0x12>
  }
  return dst;
}
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret

000000008000019a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019a:	1141                	addi	sp,sp,-16
    8000019c:	e422                	sd	s0,8(sp)
    8000019e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a0:	ca05                	beqz	a2,800001d0 <memcmp+0x36>
    800001a2:	fff6069b          	addiw	a3,a2,-1
    800001a6:	1682                	slli	a3,a3,0x20
    800001a8:	9281                	srli	a3,a3,0x20
    800001aa:	0685                	addi	a3,a3,1
    800001ac:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ae:	00054783          	lbu	a5,0(a0)
    800001b2:	0005c703          	lbu	a4,0(a1)
    800001b6:	00e79863          	bne	a5,a4,800001c6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001ba:	0505                	addi	a0,a0,1
    800001bc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001be:	fed518e3          	bne	a0,a3,800001ae <memcmp+0x14>
  }

  return 0;
    800001c2:	4501                	li	a0,0
    800001c4:	a019                	j	800001ca <memcmp+0x30>
      return *s1 - *s2;
    800001c6:	40e7853b          	subw	a0,a5,a4
}
    800001ca:	6422                	ld	s0,8(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret
  return 0;
    800001d0:	4501                	li	a0,0
    800001d2:	bfe5                	j	800001ca <memcmp+0x30>

00000000800001d4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d4:	1141                	addi	sp,sp,-16
    800001d6:	e422                	sd	s0,8(sp)
    800001d8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001da:	c205                	beqz	a2,800001fa <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001dc:	02a5e263          	bltu	a1,a0,80000200 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e0:	1602                	slli	a2,a2,0x20
    800001e2:	9201                	srli	a2,a2,0x20
    800001e4:	00c587b3          	add	a5,a1,a2
{
    800001e8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ea:	0585                	addi	a1,a1,1
    800001ec:	0705                	addi	a4,a4,1
    800001ee:	fff5c683          	lbu	a3,-1(a1)
    800001f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f6:	fef59ae3          	bne	a1,a5,800001ea <memmove+0x16>

  return dst;
}
    800001fa:	6422                	ld	s0,8(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret
  if(s < d && s + n > d){
    80000200:	02061693          	slli	a3,a2,0x20
    80000204:	9281                	srli	a3,a3,0x20
    80000206:	00d58733          	add	a4,a1,a3
    8000020a:	fce57be3          	bgeu	a0,a4,800001e0 <memmove+0xc>
    d += n;
    8000020e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000210:	fff6079b          	addiw	a5,a2,-1
    80000214:	1782                	slli	a5,a5,0x20
    80000216:	9381                	srli	a5,a5,0x20
    80000218:	fff7c793          	not	a5,a5
    8000021c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021e:	177d                	addi	a4,a4,-1
    80000220:	16fd                	addi	a3,a3,-1
    80000222:	00074603          	lbu	a2,0(a4)
    80000226:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022a:	fee79ae3          	bne	a5,a4,8000021e <memmove+0x4a>
    8000022e:	b7f1                	j	800001fa <memmove+0x26>

0000000080000230 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000230:	1141                	addi	sp,sp,-16
    80000232:	e406                	sd	ra,8(sp)
    80000234:	e022                	sd	s0,0(sp)
    80000236:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	f9c080e7          	jalr	-100(ra) # 800001d4 <memmove>
}
    80000240:	60a2                	ld	ra,8(sp)
    80000242:	6402                	ld	s0,0(sp)
    80000244:	0141                	addi	sp,sp,16
    80000246:	8082                	ret

0000000080000248 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e422                	sd	s0,8(sp)
    8000024c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000024e:	ce11                	beqz	a2,8000026a <strncmp+0x22>
    80000250:	00054783          	lbu	a5,0(a0)
    80000254:	cf89                	beqz	a5,8000026e <strncmp+0x26>
    80000256:	0005c703          	lbu	a4,0(a1)
    8000025a:	00f71a63          	bne	a4,a5,8000026e <strncmp+0x26>
    n--, p++, q++;
    8000025e:	367d                	addiw	a2,a2,-1
    80000260:	0505                	addi	a0,a0,1
    80000262:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000264:	f675                	bnez	a2,80000250 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000266:	4501                	li	a0,0
    80000268:	a809                	j	8000027a <strncmp+0x32>
    8000026a:	4501                	li	a0,0
    8000026c:	a039                	j	8000027a <strncmp+0x32>
  if(n == 0)
    8000026e:	ca09                	beqz	a2,80000280 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret
    return 0;
    80000280:	4501                	li	a0,0
    80000282:	bfe5                	j	8000027a <strncmp+0x32>

0000000080000284 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e422                	sd	s0,8(sp)
    80000288:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028a:	872a                	mv	a4,a0
    8000028c:	8832                	mv	a6,a2
    8000028e:	367d                	addiw	a2,a2,-1
    80000290:	01005963          	blez	a6,800002a2 <strncpy+0x1e>
    80000294:	0705                	addi	a4,a4,1
    80000296:	0005c783          	lbu	a5,0(a1)
    8000029a:	fef70fa3          	sb	a5,-1(a4)
    8000029e:	0585                	addi	a1,a1,1
    800002a0:	f7f5                	bnez	a5,8000028c <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a2:	86ba                	mv	a3,a4
    800002a4:	00c05c63          	blez	a2,800002bc <strncpy+0x38>
    *s++ = 0;
    800002a8:	0685                	addi	a3,a3,1
    800002aa:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002ae:	fff6c793          	not	a5,a3
    800002b2:	9fb9                	addw	a5,a5,a4
    800002b4:	010787bb          	addw	a5,a5,a6
    800002b8:	fef048e3          	bgtz	a5,800002a8 <strncpy+0x24>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	4685                	li	a3,1
    80000306:	9e89                	subw	a3,a3,a0
    80000308:	00f6853b          	addw	a0,a3,a5
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff7c703          	lbu	a4,-1(a5)
    80000312:	fb7d                	bnez	a4,80000308 <strlen+0x14>
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	b58080e7          	jalr	-1192(ra) # 80000e7e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	5a270713          	addi	a4,a4,1442 # 800088d0 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	b3c080e7          	jalr	-1220(ra) # 80000e7e <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	8e4080e7          	jalr	-1820(ra) # 80005c38 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	7e6080e7          	jalr	2022(ra) # 80001b4a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	d84080e7          	jalr	-636(ra) # 800050f0 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	030080e7          	jalr	48(ra) # 800013a4 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	784080e7          	jalr	1924(ra) # 80005b00 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	a94080e7          	jalr	-1388(ra) # 80005e18 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	8a4080e7          	jalr	-1884(ra) # 80005c38 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	894080e7          	jalr	-1900(ra) # 80005c38 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	884080e7          	jalr	-1916(ra) # 80005c38 <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d20080e7          	jalr	-736(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	34a080e7          	jalr	842(ra) # 8000070e <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	9f6080e7          	jalr	-1546(ra) # 80000dca <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	746080e7          	jalr	1862(ra) # 80001b22 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	766080e7          	jalr	1894(ra) # 80001b4a <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	cee080e7          	jalr	-786(ra) # 800050da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	cfc080e7          	jalr	-772(ra) # 800050f0 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	e98080e7          	jalr	-360(ra) # 80002294 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	53c080e7          	jalr	1340(ra) # 80002940 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	4da080e7          	jalr	1242(ra) # 800038e6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	de4080e7          	jalr	-540(ra) # 800051f8 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d6a080e7          	jalr	-662(ra) # 80001186 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	4af72323          	sw	a5,1190(a4) # 800088d0 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	49a7b783          	ld	a5,1178(a5) # 800088d8 <kernel_pagetable>
    80000446:	83b1                	srli	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	slli	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	addi	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	addi	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srli	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	addi	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	764080e7          	jalr	1892(ra) # 80005bee <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c82080e7          	jalr	-894(ra) # 80000118 <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd2080e7          	jalr	-814(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srli	a5,s1,0xc
    800004b2:	07aa                	slli	a5,a5,0xa
    800004b4:	0017e793          	ori	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addiw	s4,s4,-9
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	andi	s2,s2,511
    800004ca:	090e                	slli	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	andi	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srli	s1,s1,0xa
    800004da:	04b2                	slli	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srli	a0,s3,0xc
    800004e2:	1ff57513          	andi	a0,a0,511
    800004e6:	050e                	slli	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	addi	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srli	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	addi	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	andi	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	00a7d513          	srli	a0,a5,0xa
    8000053c:	0532                	slli	a0,a0,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	addi	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000055a:	03459793          	slli	a5,a1,0x34
    8000055e:	e7b9                	bnez	a5,800005ac <mappages+0x68>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000564:	03461793          	slli	a5,a2,0x34
    80000568:	ebb1                	bnez	a5,800005bc <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    8000056a:	c22d                	beqz	a2,800005cc <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000056c:	79fd                	lui	s3,0xfffff
    8000056e:	964e                	add	a2,a2,s3
    80000570:	00b609b3          	add	s3,a2,a1
  a = va;
    80000574:	892e                	mv	s2,a1
    80000576:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000580:	4605                	li	a2,1
    80000582:	85ca                	mv	a1,s2
    80000584:	8556                	mv	a0,s5
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	ed6080e7          	jalr	-298(ra) # 8000045c <walk>
    8000058e:	cd39                	beqz	a0,800005ec <mappages+0xa8>
    if(*pte & PTE_V)
    80000590:	611c                	ld	a5,0(a0)
    80000592:	8b85                	andi	a5,a5,1
    80000594:	e7a1                	bnez	a5,800005dc <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000596:	80b1                	srli	s1,s1,0xc
    80000598:	04aa                	slli	s1,s1,0xa
    8000059a:	0164e4b3          	or	s1,s1,s6
    8000059e:	0014e493          	ori	s1,s1,1
    800005a2:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a4:	07390063          	beq	s2,s3,80000604 <mappages+0xc0>
    a += PGSIZE;
    800005a8:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005aa:	bfc9                	j	8000057c <mappages+0x38>
    panic("mappages: va not aligned");
    800005ac:	00008517          	auipc	a0,0x8
    800005b0:	aac50513          	addi	a0,a0,-1364 # 80008058 <etext+0x58>
    800005b4:	00005097          	auipc	ra,0x5
    800005b8:	63a080e7          	jalr	1594(ra) # 80005bee <panic>
    panic("mappages: size not aligned");
    800005bc:	00008517          	auipc	a0,0x8
    800005c0:	abc50513          	addi	a0,a0,-1348 # 80008078 <etext+0x78>
    800005c4:	00005097          	auipc	ra,0x5
    800005c8:	62a080e7          	jalr	1578(ra) # 80005bee <panic>
    panic("mappages: size");
    800005cc:	00008517          	auipc	a0,0x8
    800005d0:	acc50513          	addi	a0,a0,-1332 # 80008098 <etext+0x98>
    800005d4:	00005097          	auipc	ra,0x5
    800005d8:	61a080e7          	jalr	1562(ra) # 80005bee <panic>
      panic("mappages: remap");
    800005dc:	00008517          	auipc	a0,0x8
    800005e0:	acc50513          	addi	a0,a0,-1332 # 800080a8 <etext+0xa8>
    800005e4:	00005097          	auipc	ra,0x5
    800005e8:	60a080e7          	jalr	1546(ra) # 80005bee <panic>
      return -1;
    800005ec:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ee:	60a6                	ld	ra,72(sp)
    800005f0:	6406                	ld	s0,64(sp)
    800005f2:	74e2                	ld	s1,56(sp)
    800005f4:	7942                	ld	s2,48(sp)
    800005f6:	79a2                	ld	s3,40(sp)
    800005f8:	7a02                	ld	s4,32(sp)
    800005fa:	6ae2                	ld	s5,24(sp)
    800005fc:	6b42                	ld	s6,16(sp)
    800005fe:	6ba2                	ld	s7,8(sp)
    80000600:	6161                	addi	sp,sp,80
    80000602:	8082                	ret
  return 0;
    80000604:	4501                	li	a0,0
    80000606:	b7e5                	j	800005ee <mappages+0xaa>

0000000080000608 <kvmmap>:
{
    80000608:	1141                	addi	sp,sp,-16
    8000060a:	e406                	sd	ra,8(sp)
    8000060c:	e022                	sd	s0,0(sp)
    8000060e:	0800                	addi	s0,sp,16
    80000610:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000612:	86b2                	mv	a3,a2
    80000614:	863e                	mv	a2,a5
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	f2e080e7          	jalr	-210(ra) # 80000544 <mappages>
    8000061e:	e509                	bnez	a0,80000628 <kvmmap+0x20>
}
    80000620:	60a2                	ld	ra,8(sp)
    80000622:	6402                	ld	s0,0(sp)
    80000624:	0141                	addi	sp,sp,16
    80000626:	8082                	ret
    panic("kvmmap");
    80000628:	00008517          	auipc	a0,0x8
    8000062c:	a9050513          	addi	a0,a0,-1392 # 800080b8 <etext+0xb8>
    80000630:	00005097          	auipc	ra,0x5
    80000634:	5be080e7          	jalr	1470(ra) # 80005bee <panic>

0000000080000638 <kvmmake>:
{
    80000638:	1101                	addi	sp,sp,-32
    8000063a:	ec06                	sd	ra,24(sp)
    8000063c:	e822                	sd	s0,16(sp)
    8000063e:	e426                	sd	s1,8(sp)
    80000640:	e04a                	sd	s2,0(sp)
    80000642:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000644:	00000097          	auipc	ra,0x0
    80000648:	ad4080e7          	jalr	-1324(ra) # 80000118 <kalloc>
    8000064c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000064e:	6605                	lui	a2,0x1
    80000650:	4581                	li	a1,0
    80000652:	00000097          	auipc	ra,0x0
    80000656:	b26080e7          	jalr	-1242(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000065a:	4719                	li	a4,6
    8000065c:	6685                	lui	a3,0x1
    8000065e:	10000637          	lui	a2,0x10000
    80000662:	100005b7          	lui	a1,0x10000
    80000666:	8526                	mv	a0,s1
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	fa0080e7          	jalr	-96(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000670:	4719                	li	a4,6
    80000672:	6685                	lui	a3,0x1
    80000674:	10001637          	lui	a2,0x10001
    80000678:	100015b7          	lui	a1,0x10001
    8000067c:	8526                	mv	a0,s1
    8000067e:	00000097          	auipc	ra,0x0
    80000682:	f8a080e7          	jalr	-118(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000686:	4719                	li	a4,6
    80000688:	004006b7          	lui	a3,0x400
    8000068c:	0c000637          	lui	a2,0xc000
    80000690:	0c0005b7          	lui	a1,0xc000
    80000694:	8526                	mv	a0,s1
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	f72080e7          	jalr	-142(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000069e:	00008917          	auipc	s2,0x8
    800006a2:	96290913          	addi	s2,s2,-1694 # 80008000 <etext>
    800006a6:	4729                	li	a4,10
    800006a8:	80008697          	auipc	a3,0x80008
    800006ac:	95868693          	addi	a3,a3,-1704 # 8000 <_entry-0x7fff8000>
    800006b0:	4605                	li	a2,1
    800006b2:	067e                	slli	a2,a2,0x1f
    800006b4:	85b2                	mv	a1,a2
    800006b6:	8526                	mv	a0,s1
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	f50080e7          	jalr	-176(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006c0:	4719                	li	a4,6
    800006c2:	46c5                	li	a3,17
    800006c4:	06ee                	slli	a3,a3,0x1b
    800006c6:	412686b3          	sub	a3,a3,s2
    800006ca:	864a                	mv	a2,s2
    800006cc:	85ca                	mv	a1,s2
    800006ce:	8526                	mv	a0,s1
    800006d0:	00000097          	auipc	ra,0x0
    800006d4:	f38080e7          	jalr	-200(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006d8:	4729                	li	a4,10
    800006da:	6685                	lui	a3,0x1
    800006dc:	00007617          	auipc	a2,0x7
    800006e0:	92460613          	addi	a2,a2,-1756 # 80007000 <_trampoline>
    800006e4:	040005b7          	lui	a1,0x4000
    800006e8:	15fd                	addi	a1,a1,-1
    800006ea:	05b2                	slli	a1,a1,0xc
    800006ec:	8526                	mv	a0,s1
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	f1a080e7          	jalr	-230(ra) # 80000608 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006f6:	8526                	mv	a0,s1
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	63c080e7          	jalr	1596(ra) # 80000d34 <proc_mapstacks>
}
    80000700:	8526                	mv	a0,s1
    80000702:	60e2                	ld	ra,24(sp)
    80000704:	6442                	ld	s0,16(sp)
    80000706:	64a2                	ld	s1,8(sp)
    80000708:	6902                	ld	s2,0(sp)
    8000070a:	6105                	addi	sp,sp,32
    8000070c:	8082                	ret

000000008000070e <kvminit>:
{
    8000070e:	1141                	addi	sp,sp,-16
    80000710:	e406                	sd	ra,8(sp)
    80000712:	e022                	sd	s0,0(sp)
    80000714:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	f22080e7          	jalr	-222(ra) # 80000638 <kvmmake>
    8000071e:	00008797          	auipc	a5,0x8
    80000722:	1aa7bd23          	sd	a0,442(a5) # 800088d8 <kernel_pagetable>
}
    80000726:	60a2                	ld	ra,8(sp)
    80000728:	6402                	ld	s0,0(sp)
    8000072a:	0141                	addi	sp,sp,16
    8000072c:	8082                	ret

000000008000072e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000072e:	715d                	addi	sp,sp,-80
    80000730:	e486                	sd	ra,72(sp)
    80000732:	e0a2                	sd	s0,64(sp)
    80000734:	fc26                	sd	s1,56(sp)
    80000736:	f84a                	sd	s2,48(sp)
    80000738:	f44e                	sd	s3,40(sp)
    8000073a:	f052                	sd	s4,32(sp)
    8000073c:	ec56                	sd	s5,24(sp)
    8000073e:	e85a                	sd	s6,16(sp)
    80000740:	e45e                	sd	s7,8(sp)
    80000742:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000744:	03459793          	slli	a5,a1,0x34
    80000748:	e795                	bnez	a5,80000774 <uvmunmap+0x46>
    8000074a:	8a2a                	mv	s4,a0
    8000074c:	892e                	mv	s2,a1
    8000074e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000750:	0632                	slli	a2,a2,0xc
    80000752:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000756:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000758:	6b05                	lui	s6,0x1
    8000075a:	0735e263          	bltu	a1,s3,800007be <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000075e:	60a6                	ld	ra,72(sp)
    80000760:	6406                	ld	s0,64(sp)
    80000762:	74e2                	ld	s1,56(sp)
    80000764:	7942                	ld	s2,48(sp)
    80000766:	79a2                	ld	s3,40(sp)
    80000768:	7a02                	ld	s4,32(sp)
    8000076a:	6ae2                	ld	s5,24(sp)
    8000076c:	6b42                	ld	s6,16(sp)
    8000076e:	6ba2                	ld	s7,8(sp)
    80000770:	6161                	addi	sp,sp,80
    80000772:	8082                	ret
    panic("uvmunmap: not aligned");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	94c50513          	addi	a0,a0,-1716 # 800080c0 <etext+0xc0>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	472080e7          	jalr	1138(ra) # 80005bee <panic>
      panic("uvmunmap: walk");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	95450513          	addi	a0,a0,-1708 # 800080d8 <etext+0xd8>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	462080e7          	jalr	1122(ra) # 80005bee <panic>
      panic("uvmunmap: not mapped");
    80000794:	00008517          	auipc	a0,0x8
    80000798:	95450513          	addi	a0,a0,-1708 # 800080e8 <etext+0xe8>
    8000079c:	00005097          	auipc	ra,0x5
    800007a0:	452080e7          	jalr	1106(ra) # 80005bee <panic>
      panic("uvmunmap: not a leaf");
    800007a4:	00008517          	auipc	a0,0x8
    800007a8:	95c50513          	addi	a0,a0,-1700 # 80008100 <etext+0x100>
    800007ac:	00005097          	auipc	ra,0x5
    800007b0:	442080e7          	jalr	1090(ra) # 80005bee <panic>
    *pte = 0;
    800007b4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007b8:	995a                	add	s2,s2,s6
    800007ba:	fb3972e3          	bgeu	s2,s3,8000075e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007be:	4601                	li	a2,0
    800007c0:	85ca                	mv	a1,s2
    800007c2:	8552                	mv	a0,s4
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	c98080e7          	jalr	-872(ra) # 8000045c <walk>
    800007cc:	84aa                	mv	s1,a0
    800007ce:	d95d                	beqz	a0,80000784 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007d0:	6108                	ld	a0,0(a0)
    800007d2:	00157793          	andi	a5,a0,1
    800007d6:	dfdd                	beqz	a5,80000794 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007d8:	3ff57793          	andi	a5,a0,1023
    800007dc:	fd7784e3          	beq	a5,s7,800007a4 <uvmunmap+0x76>
    if(do_free){
    800007e0:	fc0a8ae3          	beqz	s5,800007b4 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007e4:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e6:	0532                	slli	a0,a0,0xc
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	834080e7          	jalr	-1996(ra) # 8000001c <kfree>
    800007f0:	b7d1                	j	800007b4 <uvmunmap+0x86>

00000000800007f2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007f2:	1101                	addi	sp,sp,-32
    800007f4:	ec06                	sd	ra,24(sp)
    800007f6:	e822                	sd	s0,16(sp)
    800007f8:	e426                	sd	s1,8(sp)
    800007fa:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007fc:	00000097          	auipc	ra,0x0
    80000800:	91c080e7          	jalr	-1764(ra) # 80000118 <kalloc>
    80000804:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000806:	c519                	beqz	a0,80000814 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000808:	6605                	lui	a2,0x1
    8000080a:	4581                	li	a1,0
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	96c080e7          	jalr	-1684(ra) # 80000178 <memset>
  return pagetable;
}
    80000814:	8526                	mv	a0,s1
    80000816:	60e2                	ld	ra,24(sp)
    80000818:	6442                	ld	s0,16(sp)
    8000081a:	64a2                	ld	s1,8(sp)
    8000081c:	6105                	addi	sp,sp,32
    8000081e:	8082                	ret

0000000080000820 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000820:	7179                	addi	sp,sp,-48
    80000822:	f406                	sd	ra,40(sp)
    80000824:	f022                	sd	s0,32(sp)
    80000826:	ec26                	sd	s1,24(sp)
    80000828:	e84a                	sd	s2,16(sp)
    8000082a:	e44e                	sd	s3,8(sp)
    8000082c:	e052                	sd	s4,0(sp)
    8000082e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000830:	6785                	lui	a5,0x1
    80000832:	04f67863          	bgeu	a2,a5,80000882 <uvmfirst+0x62>
    80000836:	8a2a                	mv	s4,a0
    80000838:	89ae                	mv	s3,a1
    8000083a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	8dc080e7          	jalr	-1828(ra) # 80000118 <kalloc>
    80000844:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000846:	6605                	lui	a2,0x1
    80000848:	4581                	li	a1,0
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	92e080e7          	jalr	-1746(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000852:	4779                	li	a4,30
    80000854:	86ca                	mv	a3,s2
    80000856:	6605                	lui	a2,0x1
    80000858:	4581                	li	a1,0
    8000085a:	8552                	mv	a0,s4
    8000085c:	00000097          	auipc	ra,0x0
    80000860:	ce8080e7          	jalr	-792(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000864:	8626                	mv	a2,s1
    80000866:	85ce                	mv	a1,s3
    80000868:	854a                	mv	a0,s2
    8000086a:	00000097          	auipc	ra,0x0
    8000086e:	96a080e7          	jalr	-1686(ra) # 800001d4 <memmove>
}
    80000872:	70a2                	ld	ra,40(sp)
    80000874:	7402                	ld	s0,32(sp)
    80000876:	64e2                	ld	s1,24(sp)
    80000878:	6942                	ld	s2,16(sp)
    8000087a:	69a2                	ld	s3,8(sp)
    8000087c:	6a02                	ld	s4,0(sp)
    8000087e:	6145                	addi	sp,sp,48
    80000880:	8082                	ret
    panic("uvmfirst: more than a page");
    80000882:	00008517          	auipc	a0,0x8
    80000886:	89650513          	addi	a0,a0,-1898 # 80008118 <etext+0x118>
    8000088a:	00005097          	auipc	ra,0x5
    8000088e:	364080e7          	jalr	868(ra) # 80005bee <panic>

0000000080000892 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000892:	1101                	addi	sp,sp,-32
    80000894:	ec06                	sd	ra,24(sp)
    80000896:	e822                	sd	s0,16(sp)
    80000898:	e426                	sd	s1,8(sp)
    8000089a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000089c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000089e:	00b67d63          	bgeu	a2,a1,800008b8 <uvmdealloc+0x26>
    800008a2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008a4:	6785                	lui	a5,0x1
    800008a6:	17fd                	addi	a5,a5,-1
    800008a8:	00f60733          	add	a4,a2,a5
    800008ac:	767d                	lui	a2,0xfffff
    800008ae:	8f71                	and	a4,a4,a2
    800008b0:	97ae                	add	a5,a5,a1
    800008b2:	8ff1                	and	a5,a5,a2
    800008b4:	00f76863          	bltu	a4,a5,800008c4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008b8:	8526                	mv	a0,s1
    800008ba:	60e2                	ld	ra,24(sp)
    800008bc:	6442                	ld	s0,16(sp)
    800008be:	64a2                	ld	s1,8(sp)
    800008c0:	6105                	addi	sp,sp,32
    800008c2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008c4:	8f99                	sub	a5,a5,a4
    800008c6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008c8:	4685                	li	a3,1
    800008ca:	0007861b          	sext.w	a2,a5
    800008ce:	85ba                	mv	a1,a4
    800008d0:	00000097          	auipc	ra,0x0
    800008d4:	e5e080e7          	jalr	-418(ra) # 8000072e <uvmunmap>
    800008d8:	b7c5                	j	800008b8 <uvmdealloc+0x26>

00000000800008da <uvmalloc>:
  if(newsz < oldsz)
    800008da:	0ab66563          	bltu	a2,a1,80000984 <uvmalloc+0xaa>
{
    800008de:	7139                	addi	sp,sp,-64
    800008e0:	fc06                	sd	ra,56(sp)
    800008e2:	f822                	sd	s0,48(sp)
    800008e4:	f426                	sd	s1,40(sp)
    800008e6:	f04a                	sd	s2,32(sp)
    800008e8:	ec4e                	sd	s3,24(sp)
    800008ea:	e852                	sd	s4,16(sp)
    800008ec:	e456                	sd	s5,8(sp)
    800008ee:	e05a                	sd	s6,0(sp)
    800008f0:	0080                	addi	s0,sp,64
    800008f2:	8aaa                	mv	s5,a0
    800008f4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008f6:	6985                	lui	s3,0x1
    800008f8:	19fd                	addi	s3,s3,-1
    800008fa:	95ce                	add	a1,a1,s3
    800008fc:	79fd                	lui	s3,0xfffff
    800008fe:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000902:	08c9f363          	bgeu	s3,a2,80000988 <uvmalloc+0xae>
    80000906:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000908:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	80c080e7          	jalr	-2036(ra) # 80000118 <kalloc>
    80000914:	84aa                	mv	s1,a0
    if(mem == 0){
    80000916:	c51d                	beqz	a0,80000944 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000918:	6605                	lui	a2,0x1
    8000091a:	4581                	li	a1,0
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	85c080e7          	jalr	-1956(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000924:	875a                	mv	a4,s6
    80000926:	86a6                	mv	a3,s1
    80000928:	6605                	lui	a2,0x1
    8000092a:	85ca                	mv	a1,s2
    8000092c:	8556                	mv	a0,s5
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	c16080e7          	jalr	-1002(ra) # 80000544 <mappages>
    80000936:	e90d                	bnez	a0,80000968 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000938:	6785                	lui	a5,0x1
    8000093a:	993e                	add	s2,s2,a5
    8000093c:	fd4968e3          	bltu	s2,s4,8000090c <uvmalloc+0x32>
  return newsz;
    80000940:	8552                	mv	a0,s4
    80000942:	a809                	j	80000954 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f48080e7          	jalr	-184(ra) # 80000892 <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
}
    80000954:	70e2                	ld	ra,56(sp)
    80000956:	7442                	ld	s0,48(sp)
    80000958:	74a2                	ld	s1,40(sp)
    8000095a:	7902                	ld	s2,32(sp)
    8000095c:	69e2                	ld	s3,24(sp)
    8000095e:	6a42                	ld	s4,16(sp)
    80000960:	6aa2                	ld	s5,8(sp)
    80000962:	6b02                	ld	s6,0(sp)
    80000964:	6121                	addi	sp,sp,64
    80000966:	8082                	ret
      kfree(mem);
    80000968:	8526                	mv	a0,s1
    8000096a:	fffff097          	auipc	ra,0xfffff
    8000096e:	6b2080e7          	jalr	1714(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000972:	864e                	mv	a2,s3
    80000974:	85ca                	mv	a1,s2
    80000976:	8556                	mv	a0,s5
    80000978:	00000097          	auipc	ra,0x0
    8000097c:	f1a080e7          	jalr	-230(ra) # 80000892 <uvmdealloc>
      return 0;
    80000980:	4501                	li	a0,0
    80000982:	bfc9                	j	80000954 <uvmalloc+0x7a>
    return oldsz;
    80000984:	852e                	mv	a0,a1
}
    80000986:	8082                	ret
  return newsz;
    80000988:	8532                	mv	a0,a2
    8000098a:	b7e9                	j	80000954 <uvmalloc+0x7a>

000000008000098c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000098c:	7179                	addi	sp,sp,-48
    8000098e:	f406                	sd	ra,40(sp)
    80000990:	f022                	sd	s0,32(sp)
    80000992:	ec26                	sd	s1,24(sp)
    80000994:	e84a                	sd	s2,16(sp)
    80000996:	e44e                	sd	s3,8(sp)
    80000998:	e052                	sd	s4,0(sp)
    8000099a:	1800                	addi	s0,sp,48
    8000099c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000099e:	84aa                	mv	s1,a0
    800009a0:	6905                	lui	s2,0x1
    800009a2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	4985                	li	s3,1
    800009a6:	a821                	j	800009be <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009a8:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009aa:	0532                	slli	a0,a0,0xc
    800009ac:	00000097          	auipc	ra,0x0
    800009b0:	fe0080e7          	jalr	-32(ra) # 8000098c <freewalk>
      pagetable[i] = 0;
    800009b4:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009b8:	04a1                	addi	s1,s1,8
    800009ba:	03248163          	beq	s1,s2,800009dc <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009be:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c0:	00f57793          	andi	a5,a0,15
    800009c4:	ff3782e3          	beq	a5,s3,800009a8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009c8:	8905                	andi	a0,a0,1
    800009ca:	d57d                	beqz	a0,800009b8 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009cc:	00007517          	auipc	a0,0x7
    800009d0:	76c50513          	addi	a0,a0,1900 # 80008138 <etext+0x138>
    800009d4:	00005097          	auipc	ra,0x5
    800009d8:	21a080e7          	jalr	538(ra) # 80005bee <panic>
    }
  }
  kfree((void*)pagetable);
    800009dc:	8552                	mv	a0,s4
    800009de:	fffff097          	auipc	ra,0xfffff
    800009e2:	63e080e7          	jalr	1598(ra) # 8000001c <kfree>
}
    800009e6:	70a2                	ld	ra,40(sp)
    800009e8:	7402                	ld	s0,32(sp)
    800009ea:	64e2                	ld	s1,24(sp)
    800009ec:	6942                	ld	s2,16(sp)
    800009ee:	69a2                	ld	s3,8(sp)
    800009f0:	6a02                	ld	s4,0(sp)
    800009f2:	6145                	addi	sp,sp,48
    800009f4:	8082                	ret

00000000800009f6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009f6:	1101                	addi	sp,sp,-32
    800009f8:	ec06                	sd	ra,24(sp)
    800009fa:	e822                	sd	s0,16(sp)
    800009fc:	e426                	sd	s1,8(sp)
    800009fe:	1000                	addi	s0,sp,32
    80000a00:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a02:	e999                	bnez	a1,80000a18 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a04:	8526                	mv	a0,s1
    80000a06:	00000097          	auipc	ra,0x0
    80000a0a:	f86080e7          	jalr	-122(ra) # 8000098c <freewalk>
}
    80000a0e:	60e2                	ld	ra,24(sp)
    80000a10:	6442                	ld	s0,16(sp)
    80000a12:	64a2                	ld	s1,8(sp)
    80000a14:	6105                	addi	sp,sp,32
    80000a16:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a18:	6605                	lui	a2,0x1
    80000a1a:	167d                	addi	a2,a2,-1
    80000a1c:	962e                	add	a2,a2,a1
    80000a1e:	4685                	li	a3,1
    80000a20:	8231                	srli	a2,a2,0xc
    80000a22:	4581                	li	a1,0
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	d0a080e7          	jalr	-758(ra) # 8000072e <uvmunmap>
    80000a2c:	bfe1                	j	80000a04 <uvmfree+0xe>

0000000080000a2e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a2e:	c679                	beqz	a2,80000afc <uvmcopy+0xce>
{
    80000a30:	715d                	addi	sp,sp,-80
    80000a32:	e486                	sd	ra,72(sp)
    80000a34:	e0a2                	sd	s0,64(sp)
    80000a36:	fc26                	sd	s1,56(sp)
    80000a38:	f84a                	sd	s2,48(sp)
    80000a3a:	f44e                	sd	s3,40(sp)
    80000a3c:	f052                	sd	s4,32(sp)
    80000a3e:	ec56                	sd	s5,24(sp)
    80000a40:	e85a                	sd	s6,16(sp)
    80000a42:	e45e                	sd	s7,8(sp)
    80000a44:	0880                	addi	s0,sp,80
    80000a46:	8b2a                	mv	s6,a0
    80000a48:	8aae                	mv	s5,a1
    80000a4a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a4c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a4e:	4601                	li	a2,0
    80000a50:	85ce                	mv	a1,s3
    80000a52:	855a                	mv	a0,s6
    80000a54:	00000097          	auipc	ra,0x0
    80000a58:	a08080e7          	jalr	-1528(ra) # 8000045c <walk>
    80000a5c:	c531                	beqz	a0,80000aa8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a5e:	6118                	ld	a4,0(a0)
    80000a60:	00177793          	andi	a5,a4,1
    80000a64:	cbb1                	beqz	a5,80000ab8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a66:	00a75593          	srli	a1,a4,0xa
    80000a6a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a6e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a72:	fffff097          	auipc	ra,0xfffff
    80000a76:	6a6080e7          	jalr	1702(ra) # 80000118 <kalloc>
    80000a7a:	892a                	mv	s2,a0
    80000a7c:	c939                	beqz	a0,80000ad2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a7e:	6605                	lui	a2,0x1
    80000a80:	85de                	mv	a1,s7
    80000a82:	fffff097          	auipc	ra,0xfffff
    80000a86:	752080e7          	jalr	1874(ra) # 800001d4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a8a:	8726                	mv	a4,s1
    80000a8c:	86ca                	mv	a3,s2
    80000a8e:	6605                	lui	a2,0x1
    80000a90:	85ce                	mv	a1,s3
    80000a92:	8556                	mv	a0,s5
    80000a94:	00000097          	auipc	ra,0x0
    80000a98:	ab0080e7          	jalr	-1360(ra) # 80000544 <mappages>
    80000a9c:	e515                	bnez	a0,80000ac8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a9e:	6785                	lui	a5,0x1
    80000aa0:	99be                	add	s3,s3,a5
    80000aa2:	fb49e6e3          	bltu	s3,s4,80000a4e <uvmcopy+0x20>
    80000aa6:	a081                	j	80000ae6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aa8:	00007517          	auipc	a0,0x7
    80000aac:	6a050513          	addi	a0,a0,1696 # 80008148 <etext+0x148>
    80000ab0:	00005097          	auipc	ra,0x5
    80000ab4:	13e080e7          	jalr	318(ra) # 80005bee <panic>
      panic("uvmcopy: page not present");
    80000ab8:	00007517          	auipc	a0,0x7
    80000abc:	6b050513          	addi	a0,a0,1712 # 80008168 <etext+0x168>
    80000ac0:	00005097          	auipc	ra,0x5
    80000ac4:	12e080e7          	jalr	302(ra) # 80005bee <panic>
      kfree(mem);
    80000ac8:	854a                	mv	a0,s2
    80000aca:	fffff097          	auipc	ra,0xfffff
    80000ace:	552080e7          	jalr	1362(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ad2:	4685                	li	a3,1
    80000ad4:	00c9d613          	srli	a2,s3,0xc
    80000ad8:	4581                	li	a1,0
    80000ada:	8556                	mv	a0,s5
    80000adc:	00000097          	auipc	ra,0x0
    80000ae0:	c52080e7          	jalr	-942(ra) # 8000072e <uvmunmap>
  return -1;
    80000ae4:	557d                	li	a0,-1
}
    80000ae6:	60a6                	ld	ra,72(sp)
    80000ae8:	6406                	ld	s0,64(sp)
    80000aea:	74e2                	ld	s1,56(sp)
    80000aec:	7942                	ld	s2,48(sp)
    80000aee:	79a2                	ld	s3,40(sp)
    80000af0:	7a02                	ld	s4,32(sp)
    80000af2:	6ae2                	ld	s5,24(sp)
    80000af4:	6b42                	ld	s6,16(sp)
    80000af6:	6ba2                	ld	s7,8(sp)
    80000af8:	6161                	addi	sp,sp,80
    80000afa:	8082                	ret
  return 0;
    80000afc:	4501                	li	a0,0
}
    80000afe:	8082                	ret

0000000080000b00 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b00:	1141                	addi	sp,sp,-16
    80000b02:	e406                	sd	ra,8(sp)
    80000b04:	e022                	sd	s0,0(sp)
    80000b06:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b08:	4601                	li	a2,0
    80000b0a:	00000097          	auipc	ra,0x0
    80000b0e:	952080e7          	jalr	-1710(ra) # 8000045c <walk>
  if(pte == 0)
    80000b12:	c901                	beqz	a0,80000b22 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b14:	611c                	ld	a5,0(a0)
    80000b16:	9bbd                	andi	a5,a5,-17
    80000b18:	e11c                	sd	a5,0(a0)
}
    80000b1a:	60a2                	ld	ra,8(sp)
    80000b1c:	6402                	ld	s0,0(sp)
    80000b1e:	0141                	addi	sp,sp,16
    80000b20:	8082                	ret
    panic("uvmclear");
    80000b22:	00007517          	auipc	a0,0x7
    80000b26:	66650513          	addi	a0,a0,1638 # 80008188 <etext+0x188>
    80000b2a:	00005097          	auipc	ra,0x5
    80000b2e:	0c4080e7          	jalr	196(ra) # 80005bee <panic>

0000000080000b32 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b32:	cac9                	beqz	a3,80000bc4 <copyout+0x92>
{
    80000b34:	711d                	addi	sp,sp,-96
    80000b36:	ec86                	sd	ra,88(sp)
    80000b38:	e8a2                	sd	s0,80(sp)
    80000b3a:	e4a6                	sd	s1,72(sp)
    80000b3c:	e0ca                	sd	s2,64(sp)
    80000b3e:	fc4e                	sd	s3,56(sp)
    80000b40:	f852                	sd	s4,48(sp)
    80000b42:	f456                	sd	s5,40(sp)
    80000b44:	f05a                	sd	s6,32(sp)
    80000b46:	ec5e                	sd	s7,24(sp)
    80000b48:	e862                	sd	s8,16(sp)
    80000b4a:	e466                	sd	s9,8(sp)
    80000b4c:	e06a                	sd	s10,0(sp)
    80000b4e:	1080                	addi	s0,sp,96
    80000b50:	8baa                	mv	s7,a0
    80000b52:	8aae                	mv	s5,a1
    80000b54:	8b32                	mv	s6,a2
    80000b56:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b58:	74fd                	lui	s1,0xfffff
    80000b5a:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b5c:	57fd                	li	a5,-1
    80000b5e:	83e9                	srli	a5,a5,0x1a
    80000b60:	0697e463          	bltu	a5,s1,80000bc8 <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b64:	4cd5                	li	s9,21
    80000b66:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b68:	8c3e                	mv	s8,a5
    80000b6a:	a035                	j	80000b96 <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b6c:	83a9                	srli	a5,a5,0xa
    80000b6e:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b70:	409a8533          	sub	a0,s5,s1
    80000b74:	0009061b          	sext.w	a2,s2
    80000b78:	85da                	mv	a1,s6
    80000b7a:	953e                	add	a0,a0,a5
    80000b7c:	fffff097          	auipc	ra,0xfffff
    80000b80:	658080e7          	jalr	1624(ra) # 800001d4 <memmove>

    len -= n;
    80000b84:	412989b3          	sub	s3,s3,s2
    src += n;
    80000b88:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000b8a:	02098b63          	beqz	s3,80000bc0 <copyout+0x8e>
    if(va0 >= MAXVA)
    80000b8e:	034c6f63          	bltu	s8,s4,80000bcc <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000b92:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000b94:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000b96:	4601                	li	a2,0
    80000b98:	85a6                	mv	a1,s1
    80000b9a:	855e                	mv	a0,s7
    80000b9c:	00000097          	auipc	ra,0x0
    80000ba0:	8c0080e7          	jalr	-1856(ra) # 8000045c <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000ba4:	c515                	beqz	a0,80000bd0 <copyout+0x9e>
    80000ba6:	611c                	ld	a5,0(a0)
    80000ba8:	0157f713          	andi	a4,a5,21
    80000bac:	05971163          	bne	a4,s9,80000bee <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000bb0:	01a48a33          	add	s4,s1,s10
    80000bb4:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000bb8:	fb29fae3          	bgeu	s3,s2,80000b6c <copyout+0x3a>
    80000bbc:	894e                	mv	s2,s3
    80000bbe:	b77d                	j	80000b6c <copyout+0x3a>
  }
  return 0;
    80000bc0:	4501                	li	a0,0
    80000bc2:	a801                	j	80000bd2 <copyout+0xa0>
    80000bc4:	4501                	li	a0,0
}
    80000bc6:	8082                	ret
      return -1;
    80000bc8:	557d                	li	a0,-1
    80000bca:	a021                	j	80000bd2 <copyout+0xa0>
    80000bcc:	557d                	li	a0,-1
    80000bce:	a011                	j	80000bd2 <copyout+0xa0>
      return -1;
    80000bd0:	557d                	li	a0,-1
}
    80000bd2:	60e6                	ld	ra,88(sp)
    80000bd4:	6446                	ld	s0,80(sp)
    80000bd6:	64a6                	ld	s1,72(sp)
    80000bd8:	6906                	ld	s2,64(sp)
    80000bda:	79e2                	ld	s3,56(sp)
    80000bdc:	7a42                	ld	s4,48(sp)
    80000bde:	7aa2                	ld	s5,40(sp)
    80000be0:	7b02                	ld	s6,32(sp)
    80000be2:	6be2                	ld	s7,24(sp)
    80000be4:	6c42                	ld	s8,16(sp)
    80000be6:	6ca2                	ld	s9,8(sp)
    80000be8:	6d02                	ld	s10,0(sp)
    80000bea:	6125                	addi	sp,sp,96
    80000bec:	8082                	ret
      return -1;
    80000bee:	557d                	li	a0,-1
    80000bf0:	b7cd                	j	80000bd2 <copyout+0xa0>

0000000080000bf2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bf2:	caa5                	beqz	a3,80000c62 <copyin+0x70>
{
    80000bf4:	715d                	addi	sp,sp,-80
    80000bf6:	e486                	sd	ra,72(sp)
    80000bf8:	e0a2                	sd	s0,64(sp)
    80000bfa:	fc26                	sd	s1,56(sp)
    80000bfc:	f84a                	sd	s2,48(sp)
    80000bfe:	f44e                	sd	s3,40(sp)
    80000c00:	f052                	sd	s4,32(sp)
    80000c02:	ec56                	sd	s5,24(sp)
    80000c04:	e85a                	sd	s6,16(sp)
    80000c06:	e45e                	sd	s7,8(sp)
    80000c08:	e062                	sd	s8,0(sp)
    80000c0a:	0880                	addi	s0,sp,80
    80000c0c:	8b2a                	mv	s6,a0
    80000c0e:	8a2e                	mv	s4,a1
    80000c10:	8c32                	mv	s8,a2
    80000c12:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c14:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c16:	6a85                	lui	s5,0x1
    80000c18:	a01d                	j	80000c3e <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c1a:	018505b3          	add	a1,a0,s8
    80000c1e:	0004861b          	sext.w	a2,s1
    80000c22:	412585b3          	sub	a1,a1,s2
    80000c26:	8552                	mv	a0,s4
    80000c28:	fffff097          	auipc	ra,0xfffff
    80000c2c:	5ac080e7          	jalr	1452(ra) # 800001d4 <memmove>

    len -= n;
    80000c30:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c34:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c36:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c3a:	02098263          	beqz	s3,80000c5e <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c3e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c42:	85ca                	mv	a1,s2
    80000c44:	855a                	mv	a0,s6
    80000c46:	00000097          	auipc	ra,0x0
    80000c4a:	8bc080e7          	jalr	-1860(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c4e:	cd01                	beqz	a0,80000c66 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c50:	418904b3          	sub	s1,s2,s8
    80000c54:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c56:	fc99f2e3          	bgeu	s3,s1,80000c1a <copyin+0x28>
    80000c5a:	84ce                	mv	s1,s3
    80000c5c:	bf7d                	j	80000c1a <copyin+0x28>
  }
  return 0;
    80000c5e:	4501                	li	a0,0
    80000c60:	a021                	j	80000c68 <copyin+0x76>
    80000c62:	4501                	li	a0,0
}
    80000c64:	8082                	ret
      return -1;
    80000c66:	557d                	li	a0,-1
}
    80000c68:	60a6                	ld	ra,72(sp)
    80000c6a:	6406                	ld	s0,64(sp)
    80000c6c:	74e2                	ld	s1,56(sp)
    80000c6e:	7942                	ld	s2,48(sp)
    80000c70:	79a2                	ld	s3,40(sp)
    80000c72:	7a02                	ld	s4,32(sp)
    80000c74:	6ae2                	ld	s5,24(sp)
    80000c76:	6b42                	ld	s6,16(sp)
    80000c78:	6ba2                	ld	s7,8(sp)
    80000c7a:	6c02                	ld	s8,0(sp)
    80000c7c:	6161                	addi	sp,sp,80
    80000c7e:	8082                	ret

0000000080000c80 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c80:	c6c5                	beqz	a3,80000d28 <copyinstr+0xa8>
{
    80000c82:	715d                	addi	sp,sp,-80
    80000c84:	e486                	sd	ra,72(sp)
    80000c86:	e0a2                	sd	s0,64(sp)
    80000c88:	fc26                	sd	s1,56(sp)
    80000c8a:	f84a                	sd	s2,48(sp)
    80000c8c:	f44e                	sd	s3,40(sp)
    80000c8e:	f052                	sd	s4,32(sp)
    80000c90:	ec56                	sd	s5,24(sp)
    80000c92:	e85a                	sd	s6,16(sp)
    80000c94:	e45e                	sd	s7,8(sp)
    80000c96:	0880                	addi	s0,sp,80
    80000c98:	8a2a                	mv	s4,a0
    80000c9a:	8b2e                	mv	s6,a1
    80000c9c:	8bb2                	mv	s7,a2
    80000c9e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000ca0:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ca2:	6985                	lui	s3,0x1
    80000ca4:	a035                	j	80000cd0 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ca6:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000caa:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cac:	0017b793          	seqz	a5,a5
    80000cb0:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cb4:	60a6                	ld	ra,72(sp)
    80000cb6:	6406                	ld	s0,64(sp)
    80000cb8:	74e2                	ld	s1,56(sp)
    80000cba:	7942                	ld	s2,48(sp)
    80000cbc:	79a2                	ld	s3,40(sp)
    80000cbe:	7a02                	ld	s4,32(sp)
    80000cc0:	6ae2                	ld	s5,24(sp)
    80000cc2:	6b42                	ld	s6,16(sp)
    80000cc4:	6ba2                	ld	s7,8(sp)
    80000cc6:	6161                	addi	sp,sp,80
    80000cc8:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cca:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cce:	c8a9                	beqz	s1,80000d20 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cd0:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cd4:	85ca                	mv	a1,s2
    80000cd6:	8552                	mv	a0,s4
    80000cd8:	00000097          	auipc	ra,0x0
    80000cdc:	82a080e7          	jalr	-2006(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000ce0:	c131                	beqz	a0,80000d24 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000ce2:	41790833          	sub	a6,s2,s7
    80000ce6:	984e                	add	a6,a6,s3
    if(n > max)
    80000ce8:	0104f363          	bgeu	s1,a6,80000cee <copyinstr+0x6e>
    80000cec:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cee:	955e                	add	a0,a0,s7
    80000cf0:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cf4:	fc080be3          	beqz	a6,80000cca <copyinstr+0x4a>
    80000cf8:	985a                	add	a6,a6,s6
    80000cfa:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cfc:	41650633          	sub	a2,a0,s6
    80000d00:	14fd                	addi	s1,s1,-1
    80000d02:	9b26                	add	s6,s6,s1
    80000d04:	00f60733          	add	a4,a2,a5
    80000d08:	00074703          	lbu	a4,0(a4)
    80000d0c:	df49                	beqz	a4,80000ca6 <copyinstr+0x26>
        *dst = *p;
    80000d0e:	00e78023          	sb	a4,0(a5)
      --max;
    80000d12:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d16:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d18:	ff0796e3          	bne	a5,a6,80000d04 <copyinstr+0x84>
      dst++;
    80000d1c:	8b42                	mv	s6,a6
    80000d1e:	b775                	j	80000cca <copyinstr+0x4a>
    80000d20:	4781                	li	a5,0
    80000d22:	b769                	j	80000cac <copyinstr+0x2c>
      return -1;
    80000d24:	557d                	li	a0,-1
    80000d26:	b779                	j	80000cb4 <copyinstr+0x34>
  int got_null = 0;
    80000d28:	4781                	li	a5,0
  if(got_null){
    80000d2a:	0017b793          	seqz	a5,a5
    80000d2e:	40f00533          	neg	a0,a5
}
    80000d32:	8082                	ret

0000000080000d34 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d34:	7139                	addi	sp,sp,-64
    80000d36:	fc06                	sd	ra,56(sp)
    80000d38:	f822                	sd	s0,48(sp)
    80000d3a:	f426                	sd	s1,40(sp)
    80000d3c:	f04a                	sd	s2,32(sp)
    80000d3e:	ec4e                	sd	s3,24(sp)
    80000d40:	e852                	sd	s4,16(sp)
    80000d42:	e456                	sd	s5,8(sp)
    80000d44:	e05a                	sd	s6,0(sp)
    80000d46:	0080                	addi	s0,sp,64
    80000d48:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4a:	00008497          	auipc	s1,0x8
    80000d4e:	00648493          	addi	s1,s1,6 # 80008d50 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d52:	8b26                	mv	s6,s1
    80000d54:	00007a97          	auipc	s5,0x7
    80000d58:	2aca8a93          	addi	s5,s5,684 # 80008000 <etext>
    80000d5c:	04000937          	lui	s2,0x4000
    80000d60:	197d                	addi	s2,s2,-1
    80000d62:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d64:	0000ea17          	auipc	s4,0xe
    80000d68:	9eca0a13          	addi	s4,s4,-1556 # 8000e750 <tickslock>
    char *pa = kalloc();
    80000d6c:	fffff097          	auipc	ra,0xfffff
    80000d70:	3ac080e7          	jalr	940(ra) # 80000118 <kalloc>
    80000d74:	862a                	mv	a2,a0
    if(pa == 0)
    80000d76:	c131                	beqz	a0,80000dba <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d78:	416485b3          	sub	a1,s1,s6
    80000d7c:	858d                	srai	a1,a1,0x3
    80000d7e:	000ab783          	ld	a5,0(s5)
    80000d82:	02f585b3          	mul	a1,a1,a5
    80000d86:	2585                	addiw	a1,a1,1
    80000d88:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d8c:	4719                	li	a4,6
    80000d8e:	6685                	lui	a3,0x1
    80000d90:	40b905b3          	sub	a1,s2,a1
    80000d94:	854e                	mv	a0,s3
    80000d96:	00000097          	auipc	ra,0x0
    80000d9a:	872080e7          	jalr	-1934(ra) # 80000608 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d9e:	16848493          	addi	s1,s1,360
    80000da2:	fd4495e3          	bne	s1,s4,80000d6c <proc_mapstacks+0x38>
  }
}
    80000da6:	70e2                	ld	ra,56(sp)
    80000da8:	7442                	ld	s0,48(sp)
    80000daa:	74a2                	ld	s1,40(sp)
    80000dac:	7902                	ld	s2,32(sp)
    80000dae:	69e2                	ld	s3,24(sp)
    80000db0:	6a42                	ld	s4,16(sp)
    80000db2:	6aa2                	ld	s5,8(sp)
    80000db4:	6b02                	ld	s6,0(sp)
    80000db6:	6121                	addi	sp,sp,64
    80000db8:	8082                	ret
      panic("kalloc");
    80000dba:	00007517          	auipc	a0,0x7
    80000dbe:	3de50513          	addi	a0,a0,990 # 80008198 <etext+0x198>
    80000dc2:	00005097          	auipc	ra,0x5
    80000dc6:	e2c080e7          	jalr	-468(ra) # 80005bee <panic>

0000000080000dca <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000dca:	7139                	addi	sp,sp,-64
    80000dcc:	fc06                	sd	ra,56(sp)
    80000dce:	f822                	sd	s0,48(sp)
    80000dd0:	f426                	sd	s1,40(sp)
    80000dd2:	f04a                	sd	s2,32(sp)
    80000dd4:	ec4e                	sd	s3,24(sp)
    80000dd6:	e852                	sd	s4,16(sp)
    80000dd8:	e456                	sd	s5,8(sp)
    80000dda:	e05a                	sd	s6,0(sp)
    80000ddc:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dde:	00007597          	auipc	a1,0x7
    80000de2:	3c258593          	addi	a1,a1,962 # 800081a0 <etext+0x1a0>
    80000de6:	00008517          	auipc	a0,0x8
    80000dea:	b3a50513          	addi	a0,a0,-1222 # 80008920 <pid_lock>
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	2ac080e7          	jalr	684(ra) # 8000609a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000df6:	00007597          	auipc	a1,0x7
    80000dfa:	3b258593          	addi	a1,a1,946 # 800081a8 <etext+0x1a8>
    80000dfe:	00008517          	auipc	a0,0x8
    80000e02:	b3a50513          	addi	a0,a0,-1222 # 80008938 <wait_lock>
    80000e06:	00005097          	auipc	ra,0x5
    80000e0a:	294080e7          	jalr	660(ra) # 8000609a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0e:	00008497          	auipc	s1,0x8
    80000e12:	f4248493          	addi	s1,s1,-190 # 80008d50 <proc>
      initlock(&p->lock, "proc");
    80000e16:	00007b17          	auipc	s6,0x7
    80000e1a:	3a2b0b13          	addi	s6,s6,930 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e1e:	8aa6                	mv	s5,s1
    80000e20:	00007a17          	auipc	s4,0x7
    80000e24:	1e0a0a13          	addi	s4,s4,480 # 80008000 <etext>
    80000e28:	04000937          	lui	s2,0x4000
    80000e2c:	197d                	addi	s2,s2,-1
    80000e2e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e30:	0000e997          	auipc	s3,0xe
    80000e34:	92098993          	addi	s3,s3,-1760 # 8000e750 <tickslock>
      initlock(&p->lock, "proc");
    80000e38:	85da                	mv	a1,s6
    80000e3a:	8526                	mv	a0,s1
    80000e3c:	00005097          	auipc	ra,0x5
    80000e40:	25e080e7          	jalr	606(ra) # 8000609a <initlock>
      p->state = UNUSED;
    80000e44:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e48:	415487b3          	sub	a5,s1,s5
    80000e4c:	878d                	srai	a5,a5,0x3
    80000e4e:	000a3703          	ld	a4,0(s4)
    80000e52:	02e787b3          	mul	a5,a5,a4
    80000e56:	2785                	addiw	a5,a5,1
    80000e58:	00d7979b          	slliw	a5,a5,0xd
    80000e5c:	40f907b3          	sub	a5,s2,a5
    80000e60:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e62:	16848493          	addi	s1,s1,360
    80000e66:	fd3499e3          	bne	s1,s3,80000e38 <procinit+0x6e>
  }
}
    80000e6a:	70e2                	ld	ra,56(sp)
    80000e6c:	7442                	ld	s0,48(sp)
    80000e6e:	74a2                	ld	s1,40(sp)
    80000e70:	7902                	ld	s2,32(sp)
    80000e72:	69e2                	ld	s3,24(sp)
    80000e74:	6a42                	ld	s4,16(sp)
    80000e76:	6aa2                	ld	s5,8(sp)
    80000e78:	6b02                	ld	s6,0(sp)
    80000e7a:	6121                	addi	sp,sp,64
    80000e7c:	8082                	ret

0000000080000e7e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e7e:	1141                	addi	sp,sp,-16
    80000e80:	e422                	sd	s0,8(sp)
    80000e82:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e84:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e86:	2501                	sext.w	a0,a0
    80000e88:	6422                	ld	s0,8(sp)
    80000e8a:	0141                	addi	sp,sp,16
    80000e8c:	8082                	ret

0000000080000e8e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e8e:	1141                	addi	sp,sp,-16
    80000e90:	e422                	sd	s0,8(sp)
    80000e92:	0800                	addi	s0,sp,16
    80000e94:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e96:	2781                	sext.w	a5,a5
    80000e98:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e9a:	00008517          	auipc	a0,0x8
    80000e9e:	ab650513          	addi	a0,a0,-1354 # 80008950 <cpus>
    80000ea2:	953e                	add	a0,a0,a5
    80000ea4:	6422                	ld	s0,8(sp)
    80000ea6:	0141                	addi	sp,sp,16
    80000ea8:	8082                	ret

0000000080000eaa <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000eaa:	1101                	addi	sp,sp,-32
    80000eac:	ec06                	sd	ra,24(sp)
    80000eae:	e822                	sd	s0,16(sp)
    80000eb0:	e426                	sd	s1,8(sp)
    80000eb2:	1000                	addi	s0,sp,32
  push_off();
    80000eb4:	00005097          	auipc	ra,0x5
    80000eb8:	22a080e7          	jalr	554(ra) # 800060de <push_off>
    80000ebc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ebe:	2781                	sext.w	a5,a5
    80000ec0:	079e                	slli	a5,a5,0x7
    80000ec2:	00008717          	auipc	a4,0x8
    80000ec6:	a5e70713          	addi	a4,a4,-1442 # 80008920 <pid_lock>
    80000eca:	97ba                	add	a5,a5,a4
    80000ecc:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ece:	00005097          	auipc	ra,0x5
    80000ed2:	2b0080e7          	jalr	688(ra) # 8000617e <pop_off>
  return p;
}
    80000ed6:	8526                	mv	a0,s1
    80000ed8:	60e2                	ld	ra,24(sp)
    80000eda:	6442                	ld	s0,16(sp)
    80000edc:	64a2                	ld	s1,8(sp)
    80000ede:	6105                	addi	sp,sp,32
    80000ee0:	8082                	ret

0000000080000ee2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ee2:	1141                	addi	sp,sp,-16
    80000ee4:	e406                	sd	ra,8(sp)
    80000ee6:	e022                	sd	s0,0(sp)
    80000ee8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eea:	00000097          	auipc	ra,0x0
    80000eee:	fc0080e7          	jalr	-64(ra) # 80000eaa <myproc>
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	2ec080e7          	jalr	748(ra) # 800061de <release>

  if (first) {
    80000efa:	00008797          	auipc	a5,0x8
    80000efe:	9867a783          	lw	a5,-1658(a5) # 80008880 <first.1>
    80000f02:	eb89                	bnez	a5,80000f14 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f04:	00001097          	auipc	ra,0x1
    80000f08:	c5e080e7          	jalr	-930(ra) # 80001b62 <usertrapret>
}
    80000f0c:	60a2                	ld	ra,8(sp)
    80000f0e:	6402                	ld	s0,0(sp)
    80000f10:	0141                	addi	sp,sp,16
    80000f12:	8082                	ret
    fsinit(ROOTDEV);
    80000f14:	4505                	li	a0,1
    80000f16:	00002097          	auipc	ra,0x2
    80000f1a:	9aa080e7          	jalr	-1622(ra) # 800028c0 <fsinit>
    first = 0;
    80000f1e:	00008797          	auipc	a5,0x8
    80000f22:	9607a123          	sw	zero,-1694(a5) # 80008880 <first.1>
    __sync_synchronize();
    80000f26:	0ff0000f          	fence
    80000f2a:	bfe9                	j	80000f04 <forkret+0x22>

0000000080000f2c <allocpid>:
{
    80000f2c:	1101                	addi	sp,sp,-32
    80000f2e:	ec06                	sd	ra,24(sp)
    80000f30:	e822                	sd	s0,16(sp)
    80000f32:	e426                	sd	s1,8(sp)
    80000f34:	e04a                	sd	s2,0(sp)
    80000f36:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f38:	00008917          	auipc	s2,0x8
    80000f3c:	9e890913          	addi	s2,s2,-1560 # 80008920 <pid_lock>
    80000f40:	854a                	mv	a0,s2
    80000f42:	00005097          	auipc	ra,0x5
    80000f46:	1e8080e7          	jalr	488(ra) # 8000612a <acquire>
  pid = nextpid;
    80000f4a:	00008797          	auipc	a5,0x8
    80000f4e:	93a78793          	addi	a5,a5,-1734 # 80008884 <nextpid>
    80000f52:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f54:	0014871b          	addiw	a4,s1,1
    80000f58:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f5a:	854a                	mv	a0,s2
    80000f5c:	00005097          	auipc	ra,0x5
    80000f60:	282080e7          	jalr	642(ra) # 800061de <release>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret

0000000080000f72 <proc_pagetable>:
{
    80000f72:	1101                	addi	sp,sp,-32
    80000f74:	ec06                	sd	ra,24(sp)
    80000f76:	e822                	sd	s0,16(sp)
    80000f78:	e426                	sd	s1,8(sp)
    80000f7a:	e04a                	sd	s2,0(sp)
    80000f7c:	1000                	addi	s0,sp,32
    80000f7e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	872080e7          	jalr	-1934(ra) # 800007f2 <uvmcreate>
    80000f88:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f8a:	c121                	beqz	a0,80000fca <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f8c:	4729                	li	a4,10
    80000f8e:	00006697          	auipc	a3,0x6
    80000f92:	07268693          	addi	a3,a3,114 # 80007000 <_trampoline>
    80000f96:	6605                	lui	a2,0x1
    80000f98:	040005b7          	lui	a1,0x4000
    80000f9c:	15fd                	addi	a1,a1,-1
    80000f9e:	05b2                	slli	a1,a1,0xc
    80000fa0:	fffff097          	auipc	ra,0xfffff
    80000fa4:	5a4080e7          	jalr	1444(ra) # 80000544 <mappages>
    80000fa8:	02054863          	bltz	a0,80000fd8 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fac:	4719                	li	a4,6
    80000fae:	05893683          	ld	a3,88(s2)
    80000fb2:	6605                	lui	a2,0x1
    80000fb4:	020005b7          	lui	a1,0x2000
    80000fb8:	15fd                	addi	a1,a1,-1
    80000fba:	05b6                	slli	a1,a1,0xd
    80000fbc:	8526                	mv	a0,s1
    80000fbe:	fffff097          	auipc	ra,0xfffff
    80000fc2:	586080e7          	jalr	1414(ra) # 80000544 <mappages>
    80000fc6:	02054163          	bltz	a0,80000fe8 <proc_pagetable+0x76>
}
    80000fca:	8526                	mv	a0,s1
    80000fcc:	60e2                	ld	ra,24(sp)
    80000fce:	6442                	ld	s0,16(sp)
    80000fd0:	64a2                	ld	s1,8(sp)
    80000fd2:	6902                	ld	s2,0(sp)
    80000fd4:	6105                	addi	sp,sp,32
    80000fd6:	8082                	ret
    uvmfree(pagetable, 0);
    80000fd8:	4581                	li	a1,0
    80000fda:	8526                	mv	a0,s1
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	a1a080e7          	jalr	-1510(ra) # 800009f6 <uvmfree>
    return 0;
    80000fe4:	4481                	li	s1,0
    80000fe6:	b7d5                	j	80000fca <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fe8:	4681                	li	a3,0
    80000fea:	4605                	li	a2,1
    80000fec:	040005b7          	lui	a1,0x4000
    80000ff0:	15fd                	addi	a1,a1,-1
    80000ff2:	05b2                	slli	a1,a1,0xc
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	fffff097          	auipc	ra,0xfffff
    80000ffa:	738080e7          	jalr	1848(ra) # 8000072e <uvmunmap>
    uvmfree(pagetable, 0);
    80000ffe:	4581                	li	a1,0
    80001000:	8526                	mv	a0,s1
    80001002:	00000097          	auipc	ra,0x0
    80001006:	9f4080e7          	jalr	-1548(ra) # 800009f6 <uvmfree>
    return 0;
    8000100a:	4481                	li	s1,0
    8000100c:	bf7d                	j	80000fca <proc_pagetable+0x58>

000000008000100e <proc_freepagetable>:
{
    8000100e:	1101                	addi	sp,sp,-32
    80001010:	ec06                	sd	ra,24(sp)
    80001012:	e822                	sd	s0,16(sp)
    80001014:	e426                	sd	s1,8(sp)
    80001016:	e04a                	sd	s2,0(sp)
    80001018:	1000                	addi	s0,sp,32
    8000101a:	84aa                	mv	s1,a0
    8000101c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000101e:	4681                	li	a3,0
    80001020:	4605                	li	a2,1
    80001022:	040005b7          	lui	a1,0x4000
    80001026:	15fd                	addi	a1,a1,-1
    80001028:	05b2                	slli	a1,a1,0xc
    8000102a:	fffff097          	auipc	ra,0xfffff
    8000102e:	704080e7          	jalr	1796(ra) # 8000072e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001032:	4681                	li	a3,0
    80001034:	4605                	li	a2,1
    80001036:	020005b7          	lui	a1,0x2000
    8000103a:	15fd                	addi	a1,a1,-1
    8000103c:	05b6                	slli	a1,a1,0xd
    8000103e:	8526                	mv	a0,s1
    80001040:	fffff097          	auipc	ra,0xfffff
    80001044:	6ee080e7          	jalr	1774(ra) # 8000072e <uvmunmap>
  uvmfree(pagetable, sz);
    80001048:	85ca                	mv	a1,s2
    8000104a:	8526                	mv	a0,s1
    8000104c:	00000097          	auipc	ra,0x0
    80001050:	9aa080e7          	jalr	-1622(ra) # 800009f6 <uvmfree>
}
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6902                	ld	s2,0(sp)
    8000105c:	6105                	addi	sp,sp,32
    8000105e:	8082                	ret

0000000080001060 <freeproc>:
{
    80001060:	1101                	addi	sp,sp,-32
    80001062:	ec06                	sd	ra,24(sp)
    80001064:	e822                	sd	s0,16(sp)
    80001066:	e426                	sd	s1,8(sp)
    80001068:	1000                	addi	s0,sp,32
    8000106a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000106c:	6d28                	ld	a0,88(a0)
    8000106e:	c509                	beqz	a0,80001078 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001070:	fffff097          	auipc	ra,0xfffff
    80001074:	fac080e7          	jalr	-84(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001078:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000107c:	68a8                	ld	a0,80(s1)
    8000107e:	c511                	beqz	a0,8000108a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001080:	64ac                	ld	a1,72(s1)
    80001082:	00000097          	auipc	ra,0x0
    80001086:	f8c080e7          	jalr	-116(ra) # 8000100e <proc_freepagetable>
  p->pagetable = 0;
    8000108a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000108e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001092:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001096:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000109a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000109e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010a2:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010a6:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010aa:	0004ac23          	sw	zero,24(s1)
}
    800010ae:	60e2                	ld	ra,24(sp)
    800010b0:	6442                	ld	s0,16(sp)
    800010b2:	64a2                	ld	s1,8(sp)
    800010b4:	6105                	addi	sp,sp,32
    800010b6:	8082                	ret

00000000800010b8 <allocproc>:
{
    800010b8:	1101                	addi	sp,sp,-32
    800010ba:	ec06                	sd	ra,24(sp)
    800010bc:	e822                	sd	s0,16(sp)
    800010be:	e426                	sd	s1,8(sp)
    800010c0:	e04a                	sd	s2,0(sp)
    800010c2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010c4:	00008497          	auipc	s1,0x8
    800010c8:	c8c48493          	addi	s1,s1,-884 # 80008d50 <proc>
    800010cc:	0000d917          	auipc	s2,0xd
    800010d0:	68490913          	addi	s2,s2,1668 # 8000e750 <tickslock>
    acquire(&p->lock);
    800010d4:	8526                	mv	a0,s1
    800010d6:	00005097          	auipc	ra,0x5
    800010da:	054080e7          	jalr	84(ra) # 8000612a <acquire>
    if(p->state == UNUSED) {
    800010de:	4c9c                	lw	a5,24(s1)
    800010e0:	cf81                	beqz	a5,800010f8 <allocproc+0x40>
      release(&p->lock);
    800010e2:	8526                	mv	a0,s1
    800010e4:	00005097          	auipc	ra,0x5
    800010e8:	0fa080e7          	jalr	250(ra) # 800061de <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ec:	16848493          	addi	s1,s1,360
    800010f0:	ff2492e3          	bne	s1,s2,800010d4 <allocproc+0x1c>
  return 0;
    800010f4:	4481                	li	s1,0
    800010f6:	a889                	j	80001148 <allocproc+0x90>
  p->pid = allocpid();
    800010f8:	00000097          	auipc	ra,0x0
    800010fc:	e34080e7          	jalr	-460(ra) # 80000f2c <allocpid>
    80001100:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001102:	4785                	li	a5,1
    80001104:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001106:	fffff097          	auipc	ra,0xfffff
    8000110a:	012080e7          	jalr	18(ra) # 80000118 <kalloc>
    8000110e:	892a                	mv	s2,a0
    80001110:	eca8                	sd	a0,88(s1)
    80001112:	c131                	beqz	a0,80001156 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001114:	8526                	mv	a0,s1
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	e5c080e7          	jalr	-420(ra) # 80000f72 <proc_pagetable>
    8000111e:	892a                	mv	s2,a0
    80001120:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001122:	c531                	beqz	a0,8000116e <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001124:	07000613          	li	a2,112
    80001128:	4581                	li	a1,0
    8000112a:	06048513          	addi	a0,s1,96
    8000112e:	fffff097          	auipc	ra,0xfffff
    80001132:	04a080e7          	jalr	74(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001136:	00000797          	auipc	a5,0x0
    8000113a:	dac78793          	addi	a5,a5,-596 # 80000ee2 <forkret>
    8000113e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001140:	60bc                	ld	a5,64(s1)
    80001142:	6705                	lui	a4,0x1
    80001144:	97ba                	add	a5,a5,a4
    80001146:	f4bc                	sd	a5,104(s1)
}
    80001148:	8526                	mv	a0,s1
    8000114a:	60e2                	ld	ra,24(sp)
    8000114c:	6442                	ld	s0,16(sp)
    8000114e:	64a2                	ld	s1,8(sp)
    80001150:	6902                	ld	s2,0(sp)
    80001152:	6105                	addi	sp,sp,32
    80001154:	8082                	ret
    freeproc(p);
    80001156:	8526                	mv	a0,s1
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	f08080e7          	jalr	-248(ra) # 80001060 <freeproc>
    release(&p->lock);
    80001160:	8526                	mv	a0,s1
    80001162:	00005097          	auipc	ra,0x5
    80001166:	07c080e7          	jalr	124(ra) # 800061de <release>
    return 0;
    8000116a:	84ca                	mv	s1,s2
    8000116c:	bff1                	j	80001148 <allocproc+0x90>
    freeproc(p);
    8000116e:	8526                	mv	a0,s1
    80001170:	00000097          	auipc	ra,0x0
    80001174:	ef0080e7          	jalr	-272(ra) # 80001060 <freeproc>
    release(&p->lock);
    80001178:	8526                	mv	a0,s1
    8000117a:	00005097          	auipc	ra,0x5
    8000117e:	064080e7          	jalr	100(ra) # 800061de <release>
    return 0;
    80001182:	84ca                	mv	s1,s2
    80001184:	b7d1                	j	80001148 <allocproc+0x90>

0000000080001186 <userinit>:
{
    80001186:	1101                	addi	sp,sp,-32
    80001188:	ec06                	sd	ra,24(sp)
    8000118a:	e822                	sd	s0,16(sp)
    8000118c:	e426                	sd	s1,8(sp)
    8000118e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001190:	00000097          	auipc	ra,0x0
    80001194:	f28080e7          	jalr	-216(ra) # 800010b8 <allocproc>
    80001198:	84aa                	mv	s1,a0
  initproc = p;
    8000119a:	00007797          	auipc	a5,0x7
    8000119e:	74a7b323          	sd	a0,1862(a5) # 800088e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011a2:	03400613          	li	a2,52
    800011a6:	00007597          	auipc	a1,0x7
    800011aa:	6ea58593          	addi	a1,a1,1770 # 80008890 <initcode>
    800011ae:	6928                	ld	a0,80(a0)
    800011b0:	fffff097          	auipc	ra,0xfffff
    800011b4:	670080e7          	jalr	1648(ra) # 80000820 <uvmfirst>
  p->sz = PGSIZE;
    800011b8:	6785                	lui	a5,0x1
    800011ba:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011bc:	6cb8                	ld	a4,88(s1)
    800011be:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011c2:	6cb8                	ld	a4,88(s1)
    800011c4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011c6:	4641                	li	a2,16
    800011c8:	00007597          	auipc	a1,0x7
    800011cc:	ff858593          	addi	a1,a1,-8 # 800081c0 <etext+0x1c0>
    800011d0:	15848513          	addi	a0,s1,344
    800011d4:	fffff097          	auipc	ra,0xfffff
    800011d8:	0ee080e7          	jalr	238(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    800011dc:	00007517          	auipc	a0,0x7
    800011e0:	ff450513          	addi	a0,a0,-12 # 800081d0 <etext+0x1d0>
    800011e4:	00002097          	auipc	ra,0x2
    800011e8:	0fe080e7          	jalr	254(ra) # 800032e2 <namei>
    800011ec:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011f0:	478d                	li	a5,3
    800011f2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011f4:	8526                	mv	a0,s1
    800011f6:	00005097          	auipc	ra,0x5
    800011fa:	fe8080e7          	jalr	-24(ra) # 800061de <release>
}
    800011fe:	60e2                	ld	ra,24(sp)
    80001200:	6442                	ld	s0,16(sp)
    80001202:	64a2                	ld	s1,8(sp)
    80001204:	6105                	addi	sp,sp,32
    80001206:	8082                	ret

0000000080001208 <growproc>:
{
    80001208:	1101                	addi	sp,sp,-32
    8000120a:	ec06                	sd	ra,24(sp)
    8000120c:	e822                	sd	s0,16(sp)
    8000120e:	e426                	sd	s1,8(sp)
    80001210:	e04a                	sd	s2,0(sp)
    80001212:	1000                	addi	s0,sp,32
    80001214:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	c94080e7          	jalr	-876(ra) # 80000eaa <myproc>
    8000121e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001220:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001222:	01204c63          	bgtz	s2,8000123a <growproc+0x32>
  } else if(n < 0){
    80001226:	02094663          	bltz	s2,80001252 <growproc+0x4a>
  p->sz = sz;
    8000122a:	e4ac                	sd	a1,72(s1)
  return 0;
    8000122c:	4501                	li	a0,0
}
    8000122e:	60e2                	ld	ra,24(sp)
    80001230:	6442                	ld	s0,16(sp)
    80001232:	64a2                	ld	s1,8(sp)
    80001234:	6902                	ld	s2,0(sp)
    80001236:	6105                	addi	sp,sp,32
    80001238:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000123a:	4691                	li	a3,4
    8000123c:	00b90633          	add	a2,s2,a1
    80001240:	6928                	ld	a0,80(a0)
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	698080e7          	jalr	1688(ra) # 800008da <uvmalloc>
    8000124a:	85aa                	mv	a1,a0
    8000124c:	fd79                	bnez	a0,8000122a <growproc+0x22>
      return -1;
    8000124e:	557d                	li	a0,-1
    80001250:	bff9                	j	8000122e <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001252:	00b90633          	add	a2,s2,a1
    80001256:	6928                	ld	a0,80(a0)
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	63a080e7          	jalr	1594(ra) # 80000892 <uvmdealloc>
    80001260:	85aa                	mv	a1,a0
    80001262:	b7e1                	j	8000122a <growproc+0x22>

0000000080001264 <fork>:
{
    80001264:	7139                	addi	sp,sp,-64
    80001266:	fc06                	sd	ra,56(sp)
    80001268:	f822                	sd	s0,48(sp)
    8000126a:	f426                	sd	s1,40(sp)
    8000126c:	f04a                	sd	s2,32(sp)
    8000126e:	ec4e                	sd	s3,24(sp)
    80001270:	e852                	sd	s4,16(sp)
    80001272:	e456                	sd	s5,8(sp)
    80001274:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	c34080e7          	jalr	-972(ra) # 80000eaa <myproc>
    8000127e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001280:	00000097          	auipc	ra,0x0
    80001284:	e38080e7          	jalr	-456(ra) # 800010b8 <allocproc>
    80001288:	10050c63          	beqz	a0,800013a0 <fork+0x13c>
    8000128c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128e:	048ab603          	ld	a2,72(s5)
    80001292:	692c                	ld	a1,80(a0)
    80001294:	050ab503          	ld	a0,80(s5)
    80001298:	fffff097          	auipc	ra,0xfffff
    8000129c:	796080e7          	jalr	1942(ra) # 80000a2e <uvmcopy>
    800012a0:	04054863          	bltz	a0,800012f0 <fork+0x8c>
  np->sz = p->sz;
    800012a4:	048ab783          	ld	a5,72(s5)
    800012a8:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012ac:	058ab683          	ld	a3,88(s5)
    800012b0:	87b6                	mv	a5,a3
    800012b2:	058a3703          	ld	a4,88(s4)
    800012b6:	12068693          	addi	a3,a3,288
    800012ba:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012be:	6788                	ld	a0,8(a5)
    800012c0:	6b8c                	ld	a1,16(a5)
    800012c2:	6f90                	ld	a2,24(a5)
    800012c4:	01073023          	sd	a6,0(a4)
    800012c8:	e708                	sd	a0,8(a4)
    800012ca:	eb0c                	sd	a1,16(a4)
    800012cc:	ef10                	sd	a2,24(a4)
    800012ce:	02078793          	addi	a5,a5,32
    800012d2:	02070713          	addi	a4,a4,32
    800012d6:	fed792e3          	bne	a5,a3,800012ba <fork+0x56>
  np->trapframe->a0 = 0;
    800012da:	058a3783          	ld	a5,88(s4)
    800012de:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012e2:	0d0a8493          	addi	s1,s5,208
    800012e6:	0d0a0913          	addi	s2,s4,208
    800012ea:	150a8993          	addi	s3,s5,336
    800012ee:	a00d                	j	80001310 <fork+0xac>
    freeproc(np);
    800012f0:	8552                	mv	a0,s4
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	d6e080e7          	jalr	-658(ra) # 80001060 <freeproc>
    release(&np->lock);
    800012fa:	8552                	mv	a0,s4
    800012fc:	00005097          	auipc	ra,0x5
    80001300:	ee2080e7          	jalr	-286(ra) # 800061de <release>
    return -1;
    80001304:	597d                	li	s2,-1
    80001306:	a059                	j	8000138c <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001308:	04a1                	addi	s1,s1,8
    8000130a:	0921                	addi	s2,s2,8
    8000130c:	01348b63          	beq	s1,s3,80001322 <fork+0xbe>
    if(p->ofile[i])
    80001310:	6088                	ld	a0,0(s1)
    80001312:	d97d                	beqz	a0,80001308 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001314:	00002097          	auipc	ra,0x2
    80001318:	664080e7          	jalr	1636(ra) # 80003978 <filedup>
    8000131c:	00a93023          	sd	a0,0(s2)
    80001320:	b7e5                	j	80001308 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001322:	150ab503          	ld	a0,336(s5)
    80001326:	00001097          	auipc	ra,0x1
    8000132a:	7d8080e7          	jalr	2008(ra) # 80002afe <idup>
    8000132e:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001332:	4641                	li	a2,16
    80001334:	158a8593          	addi	a1,s5,344
    80001338:	158a0513          	addi	a0,s4,344
    8000133c:	fffff097          	auipc	ra,0xfffff
    80001340:	f86080e7          	jalr	-122(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001344:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001348:	8552                	mv	a0,s4
    8000134a:	00005097          	auipc	ra,0x5
    8000134e:	e94080e7          	jalr	-364(ra) # 800061de <release>
  acquire(&wait_lock);
    80001352:	00007497          	auipc	s1,0x7
    80001356:	5e648493          	addi	s1,s1,1510 # 80008938 <wait_lock>
    8000135a:	8526                	mv	a0,s1
    8000135c:	00005097          	auipc	ra,0x5
    80001360:	dce080e7          	jalr	-562(ra) # 8000612a <acquire>
  np->parent = p;
    80001364:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001368:	8526                	mv	a0,s1
    8000136a:	00005097          	auipc	ra,0x5
    8000136e:	e74080e7          	jalr	-396(ra) # 800061de <release>
  acquire(&np->lock);
    80001372:	8552                	mv	a0,s4
    80001374:	00005097          	auipc	ra,0x5
    80001378:	db6080e7          	jalr	-586(ra) # 8000612a <acquire>
  np->state = RUNNABLE;
    8000137c:	478d                	li	a5,3
    8000137e:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001382:	8552                	mv	a0,s4
    80001384:	00005097          	auipc	ra,0x5
    80001388:	e5a080e7          	jalr	-422(ra) # 800061de <release>
}
    8000138c:	854a                	mv	a0,s2
    8000138e:	70e2                	ld	ra,56(sp)
    80001390:	7442                	ld	s0,48(sp)
    80001392:	74a2                	ld	s1,40(sp)
    80001394:	7902                	ld	s2,32(sp)
    80001396:	69e2                	ld	s3,24(sp)
    80001398:	6a42                	ld	s4,16(sp)
    8000139a:	6aa2                	ld	s5,8(sp)
    8000139c:	6121                	addi	sp,sp,64
    8000139e:	8082                	ret
    return -1;
    800013a0:	597d                	li	s2,-1
    800013a2:	b7ed                	j	8000138c <fork+0x128>

00000000800013a4 <scheduler>:
{
    800013a4:	7139                	addi	sp,sp,-64
    800013a6:	fc06                	sd	ra,56(sp)
    800013a8:	f822                	sd	s0,48(sp)
    800013aa:	f426                	sd	s1,40(sp)
    800013ac:	f04a                	sd	s2,32(sp)
    800013ae:	ec4e                	sd	s3,24(sp)
    800013b0:	e852                	sd	s4,16(sp)
    800013b2:	e456                	sd	s5,8(sp)
    800013b4:	e05a                	sd	s6,0(sp)
    800013b6:	0080                	addi	s0,sp,64
    800013b8:	8792                	mv	a5,tp
  int id = r_tp();
    800013ba:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013bc:	00779a93          	slli	s5,a5,0x7
    800013c0:	00007717          	auipc	a4,0x7
    800013c4:	56070713          	addi	a4,a4,1376 # 80008920 <pid_lock>
    800013c8:	9756                	add	a4,a4,s5
    800013ca:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ce:	00007717          	auipc	a4,0x7
    800013d2:	58a70713          	addi	a4,a4,1418 # 80008958 <cpus+0x8>
    800013d6:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d8:	498d                	li	s3,3
        p->state = RUNNING;
    800013da:	4b11                	li	s6,4
        c->proc = p;
    800013dc:	079e                	slli	a5,a5,0x7
    800013de:	00007a17          	auipc	s4,0x7
    800013e2:	542a0a13          	addi	s4,s4,1346 # 80008920 <pid_lock>
    800013e6:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e8:	0000d917          	auipc	s2,0xd
    800013ec:	36890913          	addi	s2,s2,872 # 8000e750 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f8:	10079073          	csrw	sstatus,a5
    800013fc:	00008497          	auipc	s1,0x8
    80001400:	95448493          	addi	s1,s1,-1708 # 80008d50 <proc>
    80001404:	a811                	j	80001418 <scheduler+0x74>
      release(&p->lock);
    80001406:	8526                	mv	a0,s1
    80001408:	00005097          	auipc	ra,0x5
    8000140c:	dd6080e7          	jalr	-554(ra) # 800061de <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001410:	16848493          	addi	s1,s1,360
    80001414:	fd248ee3          	beq	s1,s2,800013f0 <scheduler+0x4c>
      acquire(&p->lock);
    80001418:	8526                	mv	a0,s1
    8000141a:	00005097          	auipc	ra,0x5
    8000141e:	d10080e7          	jalr	-752(ra) # 8000612a <acquire>
      if(p->state == RUNNABLE) {
    80001422:	4c9c                	lw	a5,24(s1)
    80001424:	ff3791e3          	bne	a5,s3,80001406 <scheduler+0x62>
        p->state = RUNNING;
    80001428:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000142c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001430:	06048593          	addi	a1,s1,96
    80001434:	8556                	mv	a0,s5
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	682080e7          	jalr	1666(ra) # 80001ab8 <swtch>
        c->proc = 0;
    8000143e:	020a3823          	sd	zero,48(s4)
    80001442:	b7d1                	j	80001406 <scheduler+0x62>

0000000080001444 <sched>:
{
    80001444:	7179                	addi	sp,sp,-48
    80001446:	f406                	sd	ra,40(sp)
    80001448:	f022                	sd	s0,32(sp)
    8000144a:	ec26                	sd	s1,24(sp)
    8000144c:	e84a                	sd	s2,16(sp)
    8000144e:	e44e                	sd	s3,8(sp)
    80001450:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001452:	00000097          	auipc	ra,0x0
    80001456:	a58080e7          	jalr	-1448(ra) # 80000eaa <myproc>
    8000145a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	c54080e7          	jalr	-940(ra) # 800060b0 <holding>
    80001464:	c93d                	beqz	a0,800014da <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001466:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001468:	2781                	sext.w	a5,a5
    8000146a:	079e                	slli	a5,a5,0x7
    8000146c:	00007717          	auipc	a4,0x7
    80001470:	4b470713          	addi	a4,a4,1204 # 80008920 <pid_lock>
    80001474:	97ba                	add	a5,a5,a4
    80001476:	0a87a703          	lw	a4,168(a5)
    8000147a:	4785                	li	a5,1
    8000147c:	06f71763          	bne	a4,a5,800014ea <sched+0xa6>
  if(p->state == RUNNING)
    80001480:	4c98                	lw	a4,24(s1)
    80001482:	4791                	li	a5,4
    80001484:	06f70b63          	beq	a4,a5,800014fa <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001488:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000148e:	efb5                	bnez	a5,8000150a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001490:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001492:	00007917          	auipc	s2,0x7
    80001496:	48e90913          	addi	s2,s2,1166 # 80008920 <pid_lock>
    8000149a:	2781                	sext.w	a5,a5
    8000149c:	079e                	slli	a5,a5,0x7
    8000149e:	97ca                	add	a5,a5,s2
    800014a0:	0ac7a983          	lw	s3,172(a5)
    800014a4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	slli	a5,a5,0x7
    800014aa:	00007597          	auipc	a1,0x7
    800014ae:	4ae58593          	addi	a1,a1,1198 # 80008958 <cpus+0x8>
    800014b2:	95be                	add	a1,a1,a5
    800014b4:	06048513          	addi	a0,s1,96
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	600080e7          	jalr	1536(ra) # 80001ab8 <swtch>
    800014c0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c2:	2781                	sext.w	a5,a5
    800014c4:	079e                	slli	a5,a5,0x7
    800014c6:	97ca                	add	a5,a5,s2
    800014c8:	0b37a623          	sw	s3,172(a5)
}
    800014cc:	70a2                	ld	ra,40(sp)
    800014ce:	7402                	ld	s0,32(sp)
    800014d0:	64e2                	ld	s1,24(sp)
    800014d2:	6942                	ld	s2,16(sp)
    800014d4:	69a2                	ld	s3,8(sp)
    800014d6:	6145                	addi	sp,sp,48
    800014d8:	8082                	ret
    panic("sched p->lock");
    800014da:	00007517          	auipc	a0,0x7
    800014de:	cfe50513          	addi	a0,a0,-770 # 800081d8 <etext+0x1d8>
    800014e2:	00004097          	auipc	ra,0x4
    800014e6:	70c080e7          	jalr	1804(ra) # 80005bee <panic>
    panic("sched locks");
    800014ea:	00007517          	auipc	a0,0x7
    800014ee:	cfe50513          	addi	a0,a0,-770 # 800081e8 <etext+0x1e8>
    800014f2:	00004097          	auipc	ra,0x4
    800014f6:	6fc080e7          	jalr	1788(ra) # 80005bee <panic>
    panic("sched running");
    800014fa:	00007517          	auipc	a0,0x7
    800014fe:	cfe50513          	addi	a0,a0,-770 # 800081f8 <etext+0x1f8>
    80001502:	00004097          	auipc	ra,0x4
    80001506:	6ec080e7          	jalr	1772(ra) # 80005bee <panic>
    panic("sched interruptible");
    8000150a:	00007517          	auipc	a0,0x7
    8000150e:	cfe50513          	addi	a0,a0,-770 # 80008208 <etext+0x208>
    80001512:	00004097          	auipc	ra,0x4
    80001516:	6dc080e7          	jalr	1756(ra) # 80005bee <panic>

000000008000151a <yield>:
{
    8000151a:	1101                	addi	sp,sp,-32
    8000151c:	ec06                	sd	ra,24(sp)
    8000151e:	e822                	sd	s0,16(sp)
    80001520:	e426                	sd	s1,8(sp)
    80001522:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	986080e7          	jalr	-1658(ra) # 80000eaa <myproc>
    8000152c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	bfc080e7          	jalr	-1028(ra) # 8000612a <acquire>
  p->state = RUNNABLE;
    80001536:	478d                	li	a5,3
    80001538:	cc9c                	sw	a5,24(s1)
  sched();
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	f0a080e7          	jalr	-246(ra) # 80001444 <sched>
  release(&p->lock);
    80001542:	8526                	mv	a0,s1
    80001544:	00005097          	auipc	ra,0x5
    80001548:	c9a080e7          	jalr	-870(ra) # 800061de <release>
}
    8000154c:	60e2                	ld	ra,24(sp)
    8000154e:	6442                	ld	s0,16(sp)
    80001550:	64a2                	ld	s1,8(sp)
    80001552:	6105                	addi	sp,sp,32
    80001554:	8082                	ret

0000000080001556 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001556:	7179                	addi	sp,sp,-48
    80001558:	f406                	sd	ra,40(sp)
    8000155a:	f022                	sd	s0,32(sp)
    8000155c:	ec26                	sd	s1,24(sp)
    8000155e:	e84a                	sd	s2,16(sp)
    80001560:	e44e                	sd	s3,8(sp)
    80001562:	1800                	addi	s0,sp,48
    80001564:	89aa                	mv	s3,a0
    80001566:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	942080e7          	jalr	-1726(ra) # 80000eaa <myproc>
    80001570:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	bb8080e7          	jalr	-1096(ra) # 8000612a <acquire>
  release(lk);
    8000157a:	854a                	mv	a0,s2
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	c62080e7          	jalr	-926(ra) # 800061de <release>

  // Go to sleep.
  p->chan = chan;
    80001584:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001588:	4789                	li	a5,2
    8000158a:	cc9c                	sw	a5,24(s1)

  sched();
    8000158c:	00000097          	auipc	ra,0x0
    80001590:	eb8080e7          	jalr	-328(ra) # 80001444 <sched>

  // Tidy up.
  p->chan = 0;
    80001594:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	c44080e7          	jalr	-956(ra) # 800061de <release>
  acquire(lk);
    800015a2:	854a                	mv	a0,s2
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	b86080e7          	jalr	-1146(ra) # 8000612a <acquire>
}
    800015ac:	70a2                	ld	ra,40(sp)
    800015ae:	7402                	ld	s0,32(sp)
    800015b0:	64e2                	ld	s1,24(sp)
    800015b2:	6942                	ld	s2,16(sp)
    800015b4:	69a2                	ld	s3,8(sp)
    800015b6:	6145                	addi	sp,sp,48
    800015b8:	8082                	ret

00000000800015ba <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015ba:	7139                	addi	sp,sp,-64
    800015bc:	fc06                	sd	ra,56(sp)
    800015be:	f822                	sd	s0,48(sp)
    800015c0:	f426                	sd	s1,40(sp)
    800015c2:	f04a                	sd	s2,32(sp)
    800015c4:	ec4e                	sd	s3,24(sp)
    800015c6:	e852                	sd	s4,16(sp)
    800015c8:	e456                	sd	s5,8(sp)
    800015ca:	0080                	addi	s0,sp,64
    800015cc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015ce:	00007497          	auipc	s1,0x7
    800015d2:	78248493          	addi	s1,s1,1922 # 80008d50 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015d6:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015d8:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015da:	0000d917          	auipc	s2,0xd
    800015de:	17690913          	addi	s2,s2,374 # 8000e750 <tickslock>
    800015e2:	a811                	j	800015f6 <wakeup+0x3c>
      }
      release(&p->lock);
    800015e4:	8526                	mv	a0,s1
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	bf8080e7          	jalr	-1032(ra) # 800061de <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015ee:	16848493          	addi	s1,s1,360
    800015f2:	03248663          	beq	s1,s2,8000161e <wakeup+0x64>
    if(p != myproc()){
    800015f6:	00000097          	auipc	ra,0x0
    800015fa:	8b4080e7          	jalr	-1868(ra) # 80000eaa <myproc>
    800015fe:	fea488e3          	beq	s1,a0,800015ee <wakeup+0x34>
      acquire(&p->lock);
    80001602:	8526                	mv	a0,s1
    80001604:	00005097          	auipc	ra,0x5
    80001608:	b26080e7          	jalr	-1242(ra) # 8000612a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000160c:	4c9c                	lw	a5,24(s1)
    8000160e:	fd379be3          	bne	a5,s3,800015e4 <wakeup+0x2a>
    80001612:	709c                	ld	a5,32(s1)
    80001614:	fd4798e3          	bne	a5,s4,800015e4 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001618:	0154ac23          	sw	s5,24(s1)
    8000161c:	b7e1                	j	800015e4 <wakeup+0x2a>
    }
  }
}
    8000161e:	70e2                	ld	ra,56(sp)
    80001620:	7442                	ld	s0,48(sp)
    80001622:	74a2                	ld	s1,40(sp)
    80001624:	7902                	ld	s2,32(sp)
    80001626:	69e2                	ld	s3,24(sp)
    80001628:	6a42                	ld	s4,16(sp)
    8000162a:	6aa2                	ld	s5,8(sp)
    8000162c:	6121                	addi	sp,sp,64
    8000162e:	8082                	ret

0000000080001630 <reparent>:
{
    80001630:	7179                	addi	sp,sp,-48
    80001632:	f406                	sd	ra,40(sp)
    80001634:	f022                	sd	s0,32(sp)
    80001636:	ec26                	sd	s1,24(sp)
    80001638:	e84a                	sd	s2,16(sp)
    8000163a:	e44e                	sd	s3,8(sp)
    8000163c:	e052                	sd	s4,0(sp)
    8000163e:	1800                	addi	s0,sp,48
    80001640:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001642:	00007497          	auipc	s1,0x7
    80001646:	70e48493          	addi	s1,s1,1806 # 80008d50 <proc>
      pp->parent = initproc;
    8000164a:	00007a17          	auipc	s4,0x7
    8000164e:	296a0a13          	addi	s4,s4,662 # 800088e0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001652:	0000d997          	auipc	s3,0xd
    80001656:	0fe98993          	addi	s3,s3,254 # 8000e750 <tickslock>
    8000165a:	a029                	j	80001664 <reparent+0x34>
    8000165c:	16848493          	addi	s1,s1,360
    80001660:	01348d63          	beq	s1,s3,8000167a <reparent+0x4a>
    if(pp->parent == p){
    80001664:	7c9c                	ld	a5,56(s1)
    80001666:	ff279be3          	bne	a5,s2,8000165c <reparent+0x2c>
      pp->parent = initproc;
    8000166a:	000a3503          	ld	a0,0(s4)
    8000166e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001670:	00000097          	auipc	ra,0x0
    80001674:	f4a080e7          	jalr	-182(ra) # 800015ba <wakeup>
    80001678:	b7d5                	j	8000165c <reparent+0x2c>
}
    8000167a:	70a2                	ld	ra,40(sp)
    8000167c:	7402                	ld	s0,32(sp)
    8000167e:	64e2                	ld	s1,24(sp)
    80001680:	6942                	ld	s2,16(sp)
    80001682:	69a2                	ld	s3,8(sp)
    80001684:	6a02                	ld	s4,0(sp)
    80001686:	6145                	addi	sp,sp,48
    80001688:	8082                	ret

000000008000168a <exit>:
{
    8000168a:	7179                	addi	sp,sp,-48
    8000168c:	f406                	sd	ra,40(sp)
    8000168e:	f022                	sd	s0,32(sp)
    80001690:	ec26                	sd	s1,24(sp)
    80001692:	e84a                	sd	s2,16(sp)
    80001694:	e44e                	sd	s3,8(sp)
    80001696:	e052                	sd	s4,0(sp)
    80001698:	1800                	addi	s0,sp,48
    8000169a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000169c:	00000097          	auipc	ra,0x0
    800016a0:	80e080e7          	jalr	-2034(ra) # 80000eaa <myproc>
    800016a4:	89aa                	mv	s3,a0
  if(p == initproc)
    800016a6:	00007797          	auipc	a5,0x7
    800016aa:	23a7b783          	ld	a5,570(a5) # 800088e0 <initproc>
    800016ae:	0d050493          	addi	s1,a0,208
    800016b2:	15050913          	addi	s2,a0,336
    800016b6:	02a79363          	bne	a5,a0,800016dc <exit+0x52>
    panic("init exiting");
    800016ba:	00007517          	auipc	a0,0x7
    800016be:	b6650513          	addi	a0,a0,-1178 # 80008220 <etext+0x220>
    800016c2:	00004097          	auipc	ra,0x4
    800016c6:	52c080e7          	jalr	1324(ra) # 80005bee <panic>
      fileclose(f);
    800016ca:	00002097          	auipc	ra,0x2
    800016ce:	300080e7          	jalr	768(ra) # 800039ca <fileclose>
      p->ofile[fd] = 0;
    800016d2:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016d6:	04a1                	addi	s1,s1,8
    800016d8:	01248563          	beq	s1,s2,800016e2 <exit+0x58>
    if(p->ofile[fd]){
    800016dc:	6088                	ld	a0,0(s1)
    800016de:	f575                	bnez	a0,800016ca <exit+0x40>
    800016e0:	bfdd                	j	800016d6 <exit+0x4c>
  begin_op();
    800016e2:	00002097          	auipc	ra,0x2
    800016e6:	e1c080e7          	jalr	-484(ra) # 800034fe <begin_op>
  iput(p->cwd);
    800016ea:	1509b503          	ld	a0,336(s3)
    800016ee:	00001097          	auipc	ra,0x1
    800016f2:	608080e7          	jalr	1544(ra) # 80002cf6 <iput>
  end_op();
    800016f6:	00002097          	auipc	ra,0x2
    800016fa:	e88080e7          	jalr	-376(ra) # 8000357e <end_op>
  p->cwd = 0;
    800016fe:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001702:	00007497          	auipc	s1,0x7
    80001706:	23648493          	addi	s1,s1,566 # 80008938 <wait_lock>
    8000170a:	8526                	mv	a0,s1
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	a1e080e7          	jalr	-1506(ra) # 8000612a <acquire>
  reparent(p);
    80001714:	854e                	mv	a0,s3
    80001716:	00000097          	auipc	ra,0x0
    8000171a:	f1a080e7          	jalr	-230(ra) # 80001630 <reparent>
  wakeup(p->parent);
    8000171e:	0389b503          	ld	a0,56(s3)
    80001722:	00000097          	auipc	ra,0x0
    80001726:	e98080e7          	jalr	-360(ra) # 800015ba <wakeup>
  acquire(&p->lock);
    8000172a:	854e                	mv	a0,s3
    8000172c:	00005097          	auipc	ra,0x5
    80001730:	9fe080e7          	jalr	-1538(ra) # 8000612a <acquire>
  p->xstate = status;
    80001734:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001738:	4795                	li	a5,5
    8000173a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000173e:	8526                	mv	a0,s1
    80001740:	00005097          	auipc	ra,0x5
    80001744:	a9e080e7          	jalr	-1378(ra) # 800061de <release>
  sched();
    80001748:	00000097          	auipc	ra,0x0
    8000174c:	cfc080e7          	jalr	-772(ra) # 80001444 <sched>
  panic("zombie exit");
    80001750:	00007517          	auipc	a0,0x7
    80001754:	ae050513          	addi	a0,a0,-1312 # 80008230 <etext+0x230>
    80001758:	00004097          	auipc	ra,0x4
    8000175c:	496080e7          	jalr	1174(ra) # 80005bee <panic>

0000000080001760 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001760:	7179                	addi	sp,sp,-48
    80001762:	f406                	sd	ra,40(sp)
    80001764:	f022                	sd	s0,32(sp)
    80001766:	ec26                	sd	s1,24(sp)
    80001768:	e84a                	sd	s2,16(sp)
    8000176a:	e44e                	sd	s3,8(sp)
    8000176c:	1800                	addi	s0,sp,48
    8000176e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001770:	00007497          	auipc	s1,0x7
    80001774:	5e048493          	addi	s1,s1,1504 # 80008d50 <proc>
    80001778:	0000d997          	auipc	s3,0xd
    8000177c:	fd898993          	addi	s3,s3,-40 # 8000e750 <tickslock>
    acquire(&p->lock);
    80001780:	8526                	mv	a0,s1
    80001782:	00005097          	auipc	ra,0x5
    80001786:	9a8080e7          	jalr	-1624(ra) # 8000612a <acquire>
    if(p->pid == pid){
    8000178a:	589c                	lw	a5,48(s1)
    8000178c:	01278d63          	beq	a5,s2,800017a6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001790:	8526                	mv	a0,s1
    80001792:	00005097          	auipc	ra,0x5
    80001796:	a4c080e7          	jalr	-1460(ra) # 800061de <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000179a:	16848493          	addi	s1,s1,360
    8000179e:	ff3491e3          	bne	s1,s3,80001780 <kill+0x20>
  }
  return -1;
    800017a2:	557d                	li	a0,-1
    800017a4:	a829                	j	800017be <kill+0x5e>
      p->killed = 1;
    800017a6:	4785                	li	a5,1
    800017a8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017aa:	4c98                	lw	a4,24(s1)
    800017ac:	4789                	li	a5,2
    800017ae:	00f70f63          	beq	a4,a5,800017cc <kill+0x6c>
      release(&p->lock);
    800017b2:	8526                	mv	a0,s1
    800017b4:	00005097          	auipc	ra,0x5
    800017b8:	a2a080e7          	jalr	-1494(ra) # 800061de <release>
      return 0;
    800017bc:	4501                	li	a0,0
}
    800017be:	70a2                	ld	ra,40(sp)
    800017c0:	7402                	ld	s0,32(sp)
    800017c2:	64e2                	ld	s1,24(sp)
    800017c4:	6942                	ld	s2,16(sp)
    800017c6:	69a2                	ld	s3,8(sp)
    800017c8:	6145                	addi	sp,sp,48
    800017ca:	8082                	ret
        p->state = RUNNABLE;
    800017cc:	478d                	li	a5,3
    800017ce:	cc9c                	sw	a5,24(s1)
    800017d0:	b7cd                	j	800017b2 <kill+0x52>

00000000800017d2 <setkilled>:

void
setkilled(struct proc *p)
{
    800017d2:	1101                	addi	sp,sp,-32
    800017d4:	ec06                	sd	ra,24(sp)
    800017d6:	e822                	sd	s0,16(sp)
    800017d8:	e426                	sd	s1,8(sp)
    800017da:	1000                	addi	s0,sp,32
    800017dc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017de:	00005097          	auipc	ra,0x5
    800017e2:	94c080e7          	jalr	-1716(ra) # 8000612a <acquire>
  p->killed = 1;
    800017e6:	4785                	li	a5,1
    800017e8:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017ea:	8526                	mv	a0,s1
    800017ec:	00005097          	auipc	ra,0x5
    800017f0:	9f2080e7          	jalr	-1550(ra) # 800061de <release>
}
    800017f4:	60e2                	ld	ra,24(sp)
    800017f6:	6442                	ld	s0,16(sp)
    800017f8:	64a2                	ld	s1,8(sp)
    800017fa:	6105                	addi	sp,sp,32
    800017fc:	8082                	ret

00000000800017fe <killed>:

int
killed(struct proc *p)
{
    800017fe:	1101                	addi	sp,sp,-32
    80001800:	ec06                	sd	ra,24(sp)
    80001802:	e822                	sd	s0,16(sp)
    80001804:	e426                	sd	s1,8(sp)
    80001806:	e04a                	sd	s2,0(sp)
    80001808:	1000                	addi	s0,sp,32
    8000180a:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	91e080e7          	jalr	-1762(ra) # 8000612a <acquire>
  k = p->killed;
    80001814:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	9c4080e7          	jalr	-1596(ra) # 800061de <release>
  return k;
}
    80001822:	854a                	mv	a0,s2
    80001824:	60e2                	ld	ra,24(sp)
    80001826:	6442                	ld	s0,16(sp)
    80001828:	64a2                	ld	s1,8(sp)
    8000182a:	6902                	ld	s2,0(sp)
    8000182c:	6105                	addi	sp,sp,32
    8000182e:	8082                	ret

0000000080001830 <wait>:
{
    80001830:	715d                	addi	sp,sp,-80
    80001832:	e486                	sd	ra,72(sp)
    80001834:	e0a2                	sd	s0,64(sp)
    80001836:	fc26                	sd	s1,56(sp)
    80001838:	f84a                	sd	s2,48(sp)
    8000183a:	f44e                	sd	s3,40(sp)
    8000183c:	f052                	sd	s4,32(sp)
    8000183e:	ec56                	sd	s5,24(sp)
    80001840:	e85a                	sd	s6,16(sp)
    80001842:	e45e                	sd	s7,8(sp)
    80001844:	e062                	sd	s8,0(sp)
    80001846:	0880                	addi	s0,sp,80
    80001848:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000184a:	fffff097          	auipc	ra,0xfffff
    8000184e:	660080e7          	jalr	1632(ra) # 80000eaa <myproc>
    80001852:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001854:	00007517          	auipc	a0,0x7
    80001858:	0e450513          	addi	a0,a0,228 # 80008938 <wait_lock>
    8000185c:	00005097          	auipc	ra,0x5
    80001860:	8ce080e7          	jalr	-1842(ra) # 8000612a <acquire>
    havekids = 0;
    80001864:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001866:	4a15                	li	s4,5
        havekids = 1;
    80001868:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000186a:	0000d997          	auipc	s3,0xd
    8000186e:	ee698993          	addi	s3,s3,-282 # 8000e750 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001872:	00007c17          	auipc	s8,0x7
    80001876:	0c6c0c13          	addi	s8,s8,198 # 80008938 <wait_lock>
    havekids = 0;
    8000187a:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000187c:	00007497          	auipc	s1,0x7
    80001880:	4d448493          	addi	s1,s1,1236 # 80008d50 <proc>
    80001884:	a0bd                	j	800018f2 <wait+0xc2>
          pid = pp->pid;
    80001886:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000188a:	000b0e63          	beqz	s6,800018a6 <wait+0x76>
    8000188e:	4691                	li	a3,4
    80001890:	02c48613          	addi	a2,s1,44
    80001894:	85da                	mv	a1,s6
    80001896:	05093503          	ld	a0,80(s2)
    8000189a:	fffff097          	auipc	ra,0xfffff
    8000189e:	298080e7          	jalr	664(ra) # 80000b32 <copyout>
    800018a2:	02054563          	bltz	a0,800018cc <wait+0x9c>
          freeproc(pp);
    800018a6:	8526                	mv	a0,s1
    800018a8:	fffff097          	auipc	ra,0xfffff
    800018ac:	7b8080e7          	jalr	1976(ra) # 80001060 <freeproc>
          release(&pp->lock);
    800018b0:	8526                	mv	a0,s1
    800018b2:	00005097          	auipc	ra,0x5
    800018b6:	92c080e7          	jalr	-1748(ra) # 800061de <release>
          release(&wait_lock);
    800018ba:	00007517          	auipc	a0,0x7
    800018be:	07e50513          	addi	a0,a0,126 # 80008938 <wait_lock>
    800018c2:	00005097          	auipc	ra,0x5
    800018c6:	91c080e7          	jalr	-1764(ra) # 800061de <release>
          return pid;
    800018ca:	a0b5                	j	80001936 <wait+0x106>
            release(&pp->lock);
    800018cc:	8526                	mv	a0,s1
    800018ce:	00005097          	auipc	ra,0x5
    800018d2:	910080e7          	jalr	-1776(ra) # 800061de <release>
            release(&wait_lock);
    800018d6:	00007517          	auipc	a0,0x7
    800018da:	06250513          	addi	a0,a0,98 # 80008938 <wait_lock>
    800018de:	00005097          	auipc	ra,0x5
    800018e2:	900080e7          	jalr	-1792(ra) # 800061de <release>
            return -1;
    800018e6:	59fd                	li	s3,-1
    800018e8:	a0b9                	j	80001936 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018ea:	16848493          	addi	s1,s1,360
    800018ee:	03348463          	beq	s1,s3,80001916 <wait+0xe6>
      if(pp->parent == p){
    800018f2:	7c9c                	ld	a5,56(s1)
    800018f4:	ff279be3          	bne	a5,s2,800018ea <wait+0xba>
        acquire(&pp->lock);
    800018f8:	8526                	mv	a0,s1
    800018fa:	00005097          	auipc	ra,0x5
    800018fe:	830080e7          	jalr	-2000(ra) # 8000612a <acquire>
        if(pp->state == ZOMBIE){
    80001902:	4c9c                	lw	a5,24(s1)
    80001904:	f94781e3          	beq	a5,s4,80001886 <wait+0x56>
        release(&pp->lock);
    80001908:	8526                	mv	a0,s1
    8000190a:	00005097          	auipc	ra,0x5
    8000190e:	8d4080e7          	jalr	-1836(ra) # 800061de <release>
        havekids = 1;
    80001912:	8756                	mv	a4,s5
    80001914:	bfd9                	j	800018ea <wait+0xba>
    if(!havekids || killed(p)){
    80001916:	c719                	beqz	a4,80001924 <wait+0xf4>
    80001918:	854a                	mv	a0,s2
    8000191a:	00000097          	auipc	ra,0x0
    8000191e:	ee4080e7          	jalr	-284(ra) # 800017fe <killed>
    80001922:	c51d                	beqz	a0,80001950 <wait+0x120>
      release(&wait_lock);
    80001924:	00007517          	auipc	a0,0x7
    80001928:	01450513          	addi	a0,a0,20 # 80008938 <wait_lock>
    8000192c:	00005097          	auipc	ra,0x5
    80001930:	8b2080e7          	jalr	-1870(ra) # 800061de <release>
      return -1;
    80001934:	59fd                	li	s3,-1
}
    80001936:	854e                	mv	a0,s3
    80001938:	60a6                	ld	ra,72(sp)
    8000193a:	6406                	ld	s0,64(sp)
    8000193c:	74e2                	ld	s1,56(sp)
    8000193e:	7942                	ld	s2,48(sp)
    80001940:	79a2                	ld	s3,40(sp)
    80001942:	7a02                	ld	s4,32(sp)
    80001944:	6ae2                	ld	s5,24(sp)
    80001946:	6b42                	ld	s6,16(sp)
    80001948:	6ba2                	ld	s7,8(sp)
    8000194a:	6c02                	ld	s8,0(sp)
    8000194c:	6161                	addi	sp,sp,80
    8000194e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001950:	85e2                	mv	a1,s8
    80001952:	854a                	mv	a0,s2
    80001954:	00000097          	auipc	ra,0x0
    80001958:	c02080e7          	jalr	-1022(ra) # 80001556 <sleep>
    havekids = 0;
    8000195c:	bf39                	j	8000187a <wait+0x4a>

000000008000195e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000195e:	7179                	addi	sp,sp,-48
    80001960:	f406                	sd	ra,40(sp)
    80001962:	f022                	sd	s0,32(sp)
    80001964:	ec26                	sd	s1,24(sp)
    80001966:	e84a                	sd	s2,16(sp)
    80001968:	e44e                	sd	s3,8(sp)
    8000196a:	e052                	sd	s4,0(sp)
    8000196c:	1800                	addi	s0,sp,48
    8000196e:	84aa                	mv	s1,a0
    80001970:	892e                	mv	s2,a1
    80001972:	89b2                	mv	s3,a2
    80001974:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001976:	fffff097          	auipc	ra,0xfffff
    8000197a:	534080e7          	jalr	1332(ra) # 80000eaa <myproc>
  if(user_dst){
    8000197e:	c08d                	beqz	s1,800019a0 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001980:	86d2                	mv	a3,s4
    80001982:	864e                	mv	a2,s3
    80001984:	85ca                	mv	a1,s2
    80001986:	6928                	ld	a0,80(a0)
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	1aa080e7          	jalr	426(ra) # 80000b32 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001990:	70a2                	ld	ra,40(sp)
    80001992:	7402                	ld	s0,32(sp)
    80001994:	64e2                	ld	s1,24(sp)
    80001996:	6942                	ld	s2,16(sp)
    80001998:	69a2                	ld	s3,8(sp)
    8000199a:	6a02                	ld	s4,0(sp)
    8000199c:	6145                	addi	sp,sp,48
    8000199e:	8082                	ret
    memmove((char *)dst, src, len);
    800019a0:	000a061b          	sext.w	a2,s4
    800019a4:	85ce                	mv	a1,s3
    800019a6:	854a                	mv	a0,s2
    800019a8:	fffff097          	auipc	ra,0xfffff
    800019ac:	82c080e7          	jalr	-2004(ra) # 800001d4 <memmove>
    return 0;
    800019b0:	8526                	mv	a0,s1
    800019b2:	bff9                	j	80001990 <either_copyout+0x32>

00000000800019b4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019b4:	7179                	addi	sp,sp,-48
    800019b6:	f406                	sd	ra,40(sp)
    800019b8:	f022                	sd	s0,32(sp)
    800019ba:	ec26                	sd	s1,24(sp)
    800019bc:	e84a                	sd	s2,16(sp)
    800019be:	e44e                	sd	s3,8(sp)
    800019c0:	e052                	sd	s4,0(sp)
    800019c2:	1800                	addi	s0,sp,48
    800019c4:	892a                	mv	s2,a0
    800019c6:	84ae                	mv	s1,a1
    800019c8:	89b2                	mv	s3,a2
    800019ca:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019cc:	fffff097          	auipc	ra,0xfffff
    800019d0:	4de080e7          	jalr	1246(ra) # 80000eaa <myproc>
  if(user_src){
    800019d4:	c08d                	beqz	s1,800019f6 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019d6:	86d2                	mv	a3,s4
    800019d8:	864e                	mv	a2,s3
    800019da:	85ca                	mv	a1,s2
    800019dc:	6928                	ld	a0,80(a0)
    800019de:	fffff097          	auipc	ra,0xfffff
    800019e2:	214080e7          	jalr	532(ra) # 80000bf2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019e6:	70a2                	ld	ra,40(sp)
    800019e8:	7402                	ld	s0,32(sp)
    800019ea:	64e2                	ld	s1,24(sp)
    800019ec:	6942                	ld	s2,16(sp)
    800019ee:	69a2                	ld	s3,8(sp)
    800019f0:	6a02                	ld	s4,0(sp)
    800019f2:	6145                	addi	sp,sp,48
    800019f4:	8082                	ret
    memmove(dst, (char*)src, len);
    800019f6:	000a061b          	sext.w	a2,s4
    800019fa:	85ce                	mv	a1,s3
    800019fc:	854a                	mv	a0,s2
    800019fe:	ffffe097          	auipc	ra,0xffffe
    80001a02:	7d6080e7          	jalr	2006(ra) # 800001d4 <memmove>
    return 0;
    80001a06:	8526                	mv	a0,s1
    80001a08:	bff9                	j	800019e6 <either_copyin+0x32>

0000000080001a0a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a0a:	715d                	addi	sp,sp,-80
    80001a0c:	e486                	sd	ra,72(sp)
    80001a0e:	e0a2                	sd	s0,64(sp)
    80001a10:	fc26                	sd	s1,56(sp)
    80001a12:	f84a                	sd	s2,48(sp)
    80001a14:	f44e                	sd	s3,40(sp)
    80001a16:	f052                	sd	s4,32(sp)
    80001a18:	ec56                	sd	s5,24(sp)
    80001a1a:	e85a                	sd	s6,16(sp)
    80001a1c:	e45e                	sd	s7,8(sp)
    80001a1e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a20:	00006517          	auipc	a0,0x6
    80001a24:	62850513          	addi	a0,a0,1576 # 80008048 <etext+0x48>
    80001a28:	00004097          	auipc	ra,0x4
    80001a2c:	210080e7          	jalr	528(ra) # 80005c38 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a30:	00007497          	auipc	s1,0x7
    80001a34:	47848493          	addi	s1,s1,1144 # 80008ea8 <proc+0x158>
    80001a38:	0000d917          	auipc	s2,0xd
    80001a3c:	e7090913          	addi	s2,s2,-400 # 8000e8a8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a40:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a42:	00006997          	auipc	s3,0x6
    80001a46:	7fe98993          	addi	s3,s3,2046 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001a4a:	00006a97          	auipc	s5,0x6
    80001a4e:	7fea8a93          	addi	s5,s5,2046 # 80008248 <etext+0x248>
    printf("\n");
    80001a52:	00006a17          	auipc	s4,0x6
    80001a56:	5f6a0a13          	addi	s4,s4,1526 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a5a:	00007b97          	auipc	s7,0x7
    80001a5e:	82eb8b93          	addi	s7,s7,-2002 # 80008288 <states.0>
    80001a62:	a00d                	j	80001a84 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a64:	ed86a583          	lw	a1,-296(a3)
    80001a68:	8556                	mv	a0,s5
    80001a6a:	00004097          	auipc	ra,0x4
    80001a6e:	1ce080e7          	jalr	462(ra) # 80005c38 <printf>
    printf("\n");
    80001a72:	8552                	mv	a0,s4
    80001a74:	00004097          	auipc	ra,0x4
    80001a78:	1c4080e7          	jalr	452(ra) # 80005c38 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a7c:	16848493          	addi	s1,s1,360
    80001a80:	03248163          	beq	s1,s2,80001aa2 <procdump+0x98>
    if(p->state == UNUSED)
    80001a84:	86a6                	mv	a3,s1
    80001a86:	ec04a783          	lw	a5,-320(s1)
    80001a8a:	dbed                	beqz	a5,80001a7c <procdump+0x72>
      state = "???";
    80001a8c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a8e:	fcfb6be3          	bltu	s6,a5,80001a64 <procdump+0x5a>
    80001a92:	1782                	slli	a5,a5,0x20
    80001a94:	9381                	srli	a5,a5,0x20
    80001a96:	078e                	slli	a5,a5,0x3
    80001a98:	97de                	add	a5,a5,s7
    80001a9a:	6390                	ld	a2,0(a5)
    80001a9c:	f661                	bnez	a2,80001a64 <procdump+0x5a>
      state = "???";
    80001a9e:	864e                	mv	a2,s3
    80001aa0:	b7d1                	j	80001a64 <procdump+0x5a>
  }
}
    80001aa2:	60a6                	ld	ra,72(sp)
    80001aa4:	6406                	ld	s0,64(sp)
    80001aa6:	74e2                	ld	s1,56(sp)
    80001aa8:	7942                	ld	s2,48(sp)
    80001aaa:	79a2                	ld	s3,40(sp)
    80001aac:	7a02                	ld	s4,32(sp)
    80001aae:	6ae2                	ld	s5,24(sp)
    80001ab0:	6b42                	ld	s6,16(sp)
    80001ab2:	6ba2                	ld	s7,8(sp)
    80001ab4:	6161                	addi	sp,sp,80
    80001ab6:	8082                	ret

0000000080001ab8 <swtch>:
    80001ab8:	00153023          	sd	ra,0(a0)
    80001abc:	00253423          	sd	sp,8(a0)
    80001ac0:	e900                	sd	s0,16(a0)
    80001ac2:	ed04                	sd	s1,24(a0)
    80001ac4:	03253023          	sd	s2,32(a0)
    80001ac8:	03353423          	sd	s3,40(a0)
    80001acc:	03453823          	sd	s4,48(a0)
    80001ad0:	03553c23          	sd	s5,56(a0)
    80001ad4:	05653023          	sd	s6,64(a0)
    80001ad8:	05753423          	sd	s7,72(a0)
    80001adc:	05853823          	sd	s8,80(a0)
    80001ae0:	05953c23          	sd	s9,88(a0)
    80001ae4:	07a53023          	sd	s10,96(a0)
    80001ae8:	07b53423          	sd	s11,104(a0)
    80001aec:	0005b083          	ld	ra,0(a1)
    80001af0:	0085b103          	ld	sp,8(a1)
    80001af4:	6980                	ld	s0,16(a1)
    80001af6:	6d84                	ld	s1,24(a1)
    80001af8:	0205b903          	ld	s2,32(a1)
    80001afc:	0285b983          	ld	s3,40(a1)
    80001b00:	0305ba03          	ld	s4,48(a1)
    80001b04:	0385ba83          	ld	s5,56(a1)
    80001b08:	0405bb03          	ld	s6,64(a1)
    80001b0c:	0485bb83          	ld	s7,72(a1)
    80001b10:	0505bc03          	ld	s8,80(a1)
    80001b14:	0585bc83          	ld	s9,88(a1)
    80001b18:	0605bd03          	ld	s10,96(a1)
    80001b1c:	0685bd83          	ld	s11,104(a1)
    80001b20:	8082                	ret

0000000080001b22 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b22:	1141                	addi	sp,sp,-16
    80001b24:	e406                	sd	ra,8(sp)
    80001b26:	e022                	sd	s0,0(sp)
    80001b28:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b2a:	00006597          	auipc	a1,0x6
    80001b2e:	78e58593          	addi	a1,a1,1934 # 800082b8 <states.0+0x30>
    80001b32:	0000d517          	auipc	a0,0xd
    80001b36:	c1e50513          	addi	a0,a0,-994 # 8000e750 <tickslock>
    80001b3a:	00004097          	auipc	ra,0x4
    80001b3e:	560080e7          	jalr	1376(ra) # 8000609a <initlock>
}
    80001b42:	60a2                	ld	ra,8(sp)
    80001b44:	6402                	ld	s0,0(sp)
    80001b46:	0141                	addi	sp,sp,16
    80001b48:	8082                	ret

0000000080001b4a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b4a:	1141                	addi	sp,sp,-16
    80001b4c:	e422                	sd	s0,8(sp)
    80001b4e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b50:	00003797          	auipc	a5,0x3
    80001b54:	4d078793          	addi	a5,a5,1232 # 80005020 <kernelvec>
    80001b58:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b5c:	6422                	ld	s0,8(sp)
    80001b5e:	0141                	addi	sp,sp,16
    80001b60:	8082                	ret

0000000080001b62 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b62:	1141                	addi	sp,sp,-16
    80001b64:	e406                	sd	ra,8(sp)
    80001b66:	e022                	sd	s0,0(sp)
    80001b68:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b6a:	fffff097          	auipc	ra,0xfffff
    80001b6e:	340080e7          	jalr	832(ra) # 80000eaa <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b72:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b76:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b78:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b7c:	00005617          	auipc	a2,0x5
    80001b80:	48460613          	addi	a2,a2,1156 # 80007000 <_trampoline>
    80001b84:	00005697          	auipc	a3,0x5
    80001b88:	47c68693          	addi	a3,a3,1148 # 80007000 <_trampoline>
    80001b8c:	8e91                	sub	a3,a3,a2
    80001b8e:	040007b7          	lui	a5,0x4000
    80001b92:	17fd                	addi	a5,a5,-1
    80001b94:	07b2                	slli	a5,a5,0xc
    80001b96:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b98:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b9c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b9e:	180026f3          	csrr	a3,satp
    80001ba2:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ba4:	6d38                	ld	a4,88(a0)
    80001ba6:	6134                	ld	a3,64(a0)
    80001ba8:	6585                	lui	a1,0x1
    80001baa:	96ae                	add	a3,a3,a1
    80001bac:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bae:	6d38                	ld	a4,88(a0)
    80001bb0:	00000697          	auipc	a3,0x0
    80001bb4:	13068693          	addi	a3,a3,304 # 80001ce0 <usertrap>
    80001bb8:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bba:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bbc:	8692                	mv	a3,tp
    80001bbe:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bc0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bc4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bc8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bcc:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bd0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bd2:	6f18                	ld	a4,24(a4)
    80001bd4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bd8:	6928                	ld	a0,80(a0)
    80001bda:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bdc:	00005717          	auipc	a4,0x5
    80001be0:	4c070713          	addi	a4,a4,1216 # 8000709c <userret>
    80001be4:	8f11                	sub	a4,a4,a2
    80001be6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001be8:	577d                	li	a4,-1
    80001bea:	177e                	slli	a4,a4,0x3f
    80001bec:	8d59                	or	a0,a0,a4
    80001bee:	9782                	jalr	a5
}
    80001bf0:	60a2                	ld	ra,8(sp)
    80001bf2:	6402                	ld	s0,0(sp)
    80001bf4:	0141                	addi	sp,sp,16
    80001bf6:	8082                	ret

0000000080001bf8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bf8:	1101                	addi	sp,sp,-32
    80001bfa:	ec06                	sd	ra,24(sp)
    80001bfc:	e822                	sd	s0,16(sp)
    80001bfe:	e426                	sd	s1,8(sp)
    80001c00:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c02:	0000d497          	auipc	s1,0xd
    80001c06:	b4e48493          	addi	s1,s1,-1202 # 8000e750 <tickslock>
    80001c0a:	8526                	mv	a0,s1
    80001c0c:	00004097          	auipc	ra,0x4
    80001c10:	51e080e7          	jalr	1310(ra) # 8000612a <acquire>
  ticks++;
    80001c14:	00007517          	auipc	a0,0x7
    80001c18:	cd450513          	addi	a0,a0,-812 # 800088e8 <ticks>
    80001c1c:	411c                	lw	a5,0(a0)
    80001c1e:	2785                	addiw	a5,a5,1
    80001c20:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c22:	00000097          	auipc	ra,0x0
    80001c26:	998080e7          	jalr	-1640(ra) # 800015ba <wakeup>
  release(&tickslock);
    80001c2a:	8526                	mv	a0,s1
    80001c2c:	00004097          	auipc	ra,0x4
    80001c30:	5b2080e7          	jalr	1458(ra) # 800061de <release>
}
    80001c34:	60e2                	ld	ra,24(sp)
    80001c36:	6442                	ld	s0,16(sp)
    80001c38:	64a2                	ld	s1,8(sp)
    80001c3a:	6105                	addi	sp,sp,32
    80001c3c:	8082                	ret

0000000080001c3e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c3e:	1101                	addi	sp,sp,-32
    80001c40:	ec06                	sd	ra,24(sp)
    80001c42:	e822                	sd	s0,16(sp)
    80001c44:	e426                	sd	s1,8(sp)
    80001c46:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c48:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c4c:	00074d63          	bltz	a4,80001c66 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c50:	57fd                	li	a5,-1
    80001c52:	17fe                	slli	a5,a5,0x3f
    80001c54:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c56:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c58:	06f70363          	beq	a4,a5,80001cbe <devintr+0x80>
  }
}
    80001c5c:	60e2                	ld	ra,24(sp)
    80001c5e:	6442                	ld	s0,16(sp)
    80001c60:	64a2                	ld	s1,8(sp)
    80001c62:	6105                	addi	sp,sp,32
    80001c64:	8082                	ret
     (scause & 0xff) == 9){
    80001c66:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c6a:	46a5                	li	a3,9
    80001c6c:	fed792e3          	bne	a5,a3,80001c50 <devintr+0x12>
    int irq = plic_claim();
    80001c70:	00003097          	auipc	ra,0x3
    80001c74:	4b8080e7          	jalr	1208(ra) # 80005128 <plic_claim>
    80001c78:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c7a:	47a9                	li	a5,10
    80001c7c:	02f50763          	beq	a0,a5,80001caa <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c80:	4785                	li	a5,1
    80001c82:	02f50963          	beq	a0,a5,80001cb4 <devintr+0x76>
    return 1;
    80001c86:	4505                	li	a0,1
    } else if(irq){
    80001c88:	d8f1                	beqz	s1,80001c5c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c8a:	85a6                	mv	a1,s1
    80001c8c:	00006517          	auipc	a0,0x6
    80001c90:	63450513          	addi	a0,a0,1588 # 800082c0 <states.0+0x38>
    80001c94:	00004097          	auipc	ra,0x4
    80001c98:	fa4080e7          	jalr	-92(ra) # 80005c38 <printf>
      plic_complete(irq);
    80001c9c:	8526                	mv	a0,s1
    80001c9e:	00003097          	auipc	ra,0x3
    80001ca2:	4ae080e7          	jalr	1198(ra) # 8000514c <plic_complete>
    return 1;
    80001ca6:	4505                	li	a0,1
    80001ca8:	bf55                	j	80001c5c <devintr+0x1e>
      uartintr();
    80001caa:	00004097          	auipc	ra,0x4
    80001cae:	3a0080e7          	jalr	928(ra) # 8000604a <uartintr>
    80001cb2:	b7ed                	j	80001c9c <devintr+0x5e>
      virtio_disk_intr();
    80001cb4:	00004097          	auipc	ra,0x4
    80001cb8:	964080e7          	jalr	-1692(ra) # 80005618 <virtio_disk_intr>
    80001cbc:	b7c5                	j	80001c9c <devintr+0x5e>
    if(cpuid() == 0){
    80001cbe:	fffff097          	auipc	ra,0xfffff
    80001cc2:	1c0080e7          	jalr	448(ra) # 80000e7e <cpuid>
    80001cc6:	c901                	beqz	a0,80001cd6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cc8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ccc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cce:	14479073          	csrw	sip,a5
    return 2;
    80001cd2:	4509                	li	a0,2
    80001cd4:	b761                	j	80001c5c <devintr+0x1e>
      clockintr();
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	f22080e7          	jalr	-222(ra) # 80001bf8 <clockintr>
    80001cde:	b7ed                	j	80001cc8 <devintr+0x8a>

0000000080001ce0 <usertrap>:
{
    80001ce0:	1101                	addi	sp,sp,-32
    80001ce2:	ec06                	sd	ra,24(sp)
    80001ce4:	e822                	sd	s0,16(sp)
    80001ce6:	e426                	sd	s1,8(sp)
    80001ce8:	e04a                	sd	s2,0(sp)
    80001cea:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cec:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf0:	1007f793          	andi	a5,a5,256
    80001cf4:	e3b1                	bnez	a5,80001d38 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf6:	00003797          	auipc	a5,0x3
    80001cfa:	32a78793          	addi	a5,a5,810 # 80005020 <kernelvec>
    80001cfe:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d02:	fffff097          	auipc	ra,0xfffff
    80001d06:	1a8080e7          	jalr	424(ra) # 80000eaa <myproc>
    80001d0a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d0c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d0e:	14102773          	csrr	a4,sepc
    80001d12:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d14:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d18:	47a1                	li	a5,8
    80001d1a:	02f70763          	beq	a4,a5,80001d48 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d1e:	00000097          	auipc	ra,0x0
    80001d22:	f20080e7          	jalr	-224(ra) # 80001c3e <devintr>
    80001d26:	892a                	mv	s2,a0
    80001d28:	c151                	beqz	a0,80001dac <usertrap+0xcc>
  if(killed(p))
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	00000097          	auipc	ra,0x0
    80001d30:	ad2080e7          	jalr	-1326(ra) # 800017fe <killed>
    80001d34:	c929                	beqz	a0,80001d86 <usertrap+0xa6>
    80001d36:	a099                	j	80001d7c <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d38:	00006517          	auipc	a0,0x6
    80001d3c:	5a850513          	addi	a0,a0,1448 # 800082e0 <states.0+0x58>
    80001d40:	00004097          	auipc	ra,0x4
    80001d44:	eae080e7          	jalr	-338(ra) # 80005bee <panic>
    if(killed(p))
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	ab6080e7          	jalr	-1354(ra) # 800017fe <killed>
    80001d50:	e921                	bnez	a0,80001da0 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d52:	6cb8                	ld	a4,88(s1)
    80001d54:	6f1c                	ld	a5,24(a4)
    80001d56:	0791                	addi	a5,a5,4
    80001d58:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d5e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d62:	10079073          	csrw	sstatus,a5
    syscall();
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	2d4080e7          	jalr	724(ra) # 8000203a <syscall>
  if(killed(p))
    80001d6e:	8526                	mv	a0,s1
    80001d70:	00000097          	auipc	ra,0x0
    80001d74:	a8e080e7          	jalr	-1394(ra) # 800017fe <killed>
    80001d78:	c911                	beqz	a0,80001d8c <usertrap+0xac>
    80001d7a:	4901                	li	s2,0
    exit(-1);
    80001d7c:	557d                	li	a0,-1
    80001d7e:	00000097          	auipc	ra,0x0
    80001d82:	90c080e7          	jalr	-1780(ra) # 8000168a <exit>
  if(which_dev == 2)
    80001d86:	4789                	li	a5,2
    80001d88:	04f90f63          	beq	s2,a5,80001de6 <usertrap+0x106>
  usertrapret();
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	dd6080e7          	jalr	-554(ra) # 80001b62 <usertrapret>
}
    80001d94:	60e2                	ld	ra,24(sp)
    80001d96:	6442                	ld	s0,16(sp)
    80001d98:	64a2                	ld	s1,8(sp)
    80001d9a:	6902                	ld	s2,0(sp)
    80001d9c:	6105                	addi	sp,sp,32
    80001d9e:	8082                	ret
      exit(-1);
    80001da0:	557d                	li	a0,-1
    80001da2:	00000097          	auipc	ra,0x0
    80001da6:	8e8080e7          	jalr	-1816(ra) # 8000168a <exit>
    80001daa:	b765                	j	80001d52 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dac:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001db0:	5890                	lw	a2,48(s1)
    80001db2:	00006517          	auipc	a0,0x6
    80001db6:	54e50513          	addi	a0,a0,1358 # 80008300 <states.0+0x78>
    80001dba:	00004097          	auipc	ra,0x4
    80001dbe:	e7e080e7          	jalr	-386(ra) # 80005c38 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dc2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dc6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dca:	00006517          	auipc	a0,0x6
    80001dce:	56650513          	addi	a0,a0,1382 # 80008330 <states.0+0xa8>
    80001dd2:	00004097          	auipc	ra,0x4
    80001dd6:	e66080e7          	jalr	-410(ra) # 80005c38 <printf>
    setkilled(p);
    80001dda:	8526                	mv	a0,s1
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	9f6080e7          	jalr	-1546(ra) # 800017d2 <setkilled>
    80001de4:	b769                	j	80001d6e <usertrap+0x8e>
    yield();
    80001de6:	fffff097          	auipc	ra,0xfffff
    80001dea:	734080e7          	jalr	1844(ra) # 8000151a <yield>
    80001dee:	bf79                	j	80001d8c <usertrap+0xac>

0000000080001df0 <kerneltrap>:
{
    80001df0:	7179                	addi	sp,sp,-48
    80001df2:	f406                	sd	ra,40(sp)
    80001df4:	f022                	sd	s0,32(sp)
    80001df6:	ec26                	sd	s1,24(sp)
    80001df8:	e84a                	sd	s2,16(sp)
    80001dfa:	e44e                	sd	s3,8(sp)
    80001dfc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dfe:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e02:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e06:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e0a:	1004f793          	andi	a5,s1,256
    80001e0e:	cb85                	beqz	a5,80001e3e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e10:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e14:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e16:	ef85                	bnez	a5,80001e4e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e18:	00000097          	auipc	ra,0x0
    80001e1c:	e26080e7          	jalr	-474(ra) # 80001c3e <devintr>
    80001e20:	cd1d                	beqz	a0,80001e5e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e22:	4789                	li	a5,2
    80001e24:	06f50a63          	beq	a0,a5,80001e98 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e28:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2c:	10049073          	csrw	sstatus,s1
}
    80001e30:	70a2                	ld	ra,40(sp)
    80001e32:	7402                	ld	s0,32(sp)
    80001e34:	64e2                	ld	s1,24(sp)
    80001e36:	6942                	ld	s2,16(sp)
    80001e38:	69a2                	ld	s3,8(sp)
    80001e3a:	6145                	addi	sp,sp,48
    80001e3c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e3e:	00006517          	auipc	a0,0x6
    80001e42:	51250513          	addi	a0,a0,1298 # 80008350 <states.0+0xc8>
    80001e46:	00004097          	auipc	ra,0x4
    80001e4a:	da8080e7          	jalr	-600(ra) # 80005bee <panic>
    panic("kerneltrap: interrupts enabled");
    80001e4e:	00006517          	auipc	a0,0x6
    80001e52:	52a50513          	addi	a0,a0,1322 # 80008378 <states.0+0xf0>
    80001e56:	00004097          	auipc	ra,0x4
    80001e5a:	d98080e7          	jalr	-616(ra) # 80005bee <panic>
    printf("scause %p\n", scause);
    80001e5e:	85ce                	mv	a1,s3
    80001e60:	00006517          	auipc	a0,0x6
    80001e64:	53850513          	addi	a0,a0,1336 # 80008398 <states.0+0x110>
    80001e68:	00004097          	auipc	ra,0x4
    80001e6c:	dd0080e7          	jalr	-560(ra) # 80005c38 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e70:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e74:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e78:	00006517          	auipc	a0,0x6
    80001e7c:	53050513          	addi	a0,a0,1328 # 800083a8 <states.0+0x120>
    80001e80:	00004097          	auipc	ra,0x4
    80001e84:	db8080e7          	jalr	-584(ra) # 80005c38 <printf>
    panic("kerneltrap");
    80001e88:	00006517          	auipc	a0,0x6
    80001e8c:	53850513          	addi	a0,a0,1336 # 800083c0 <states.0+0x138>
    80001e90:	00004097          	auipc	ra,0x4
    80001e94:	d5e080e7          	jalr	-674(ra) # 80005bee <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	012080e7          	jalr	18(ra) # 80000eaa <myproc>
    80001ea0:	d541                	beqz	a0,80001e28 <kerneltrap+0x38>
    80001ea2:	fffff097          	auipc	ra,0xfffff
    80001ea6:	008080e7          	jalr	8(ra) # 80000eaa <myproc>
    80001eaa:	4d18                	lw	a4,24(a0)
    80001eac:	4791                	li	a5,4
    80001eae:	f6f71de3          	bne	a4,a5,80001e28 <kerneltrap+0x38>
    yield();
    80001eb2:	fffff097          	auipc	ra,0xfffff
    80001eb6:	668080e7          	jalr	1640(ra) # 8000151a <yield>
    80001eba:	b7bd                	j	80001e28 <kerneltrap+0x38>

0000000080001ebc <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ebc:	1101                	addi	sp,sp,-32
    80001ebe:	ec06                	sd	ra,24(sp)
    80001ec0:	e822                	sd	s0,16(sp)
    80001ec2:	e426                	sd	s1,8(sp)
    80001ec4:	1000                	addi	s0,sp,32
    80001ec6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	fe2080e7          	jalr	-30(ra) # 80000eaa <myproc>
  switch (n) {
    80001ed0:	4795                	li	a5,5
    80001ed2:	0497e163          	bltu	a5,s1,80001f14 <argraw+0x58>
    80001ed6:	048a                	slli	s1,s1,0x2
    80001ed8:	00006717          	auipc	a4,0x6
    80001edc:	52070713          	addi	a4,a4,1312 # 800083f8 <states.0+0x170>
    80001ee0:	94ba                	add	s1,s1,a4
    80001ee2:	409c                	lw	a5,0(s1)
    80001ee4:	97ba                	add	a5,a5,a4
    80001ee6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ee8:	6d3c                	ld	a5,88(a0)
    80001eea:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eec:	60e2                	ld	ra,24(sp)
    80001eee:	6442                	ld	s0,16(sp)
    80001ef0:	64a2                	ld	s1,8(sp)
    80001ef2:	6105                	addi	sp,sp,32
    80001ef4:	8082                	ret
    return p->trapframe->a1;
    80001ef6:	6d3c                	ld	a5,88(a0)
    80001ef8:	7fa8                	ld	a0,120(a5)
    80001efa:	bfcd                	j	80001eec <argraw+0x30>
    return p->trapframe->a2;
    80001efc:	6d3c                	ld	a5,88(a0)
    80001efe:	63c8                	ld	a0,128(a5)
    80001f00:	b7f5                	j	80001eec <argraw+0x30>
    return p->trapframe->a3;
    80001f02:	6d3c                	ld	a5,88(a0)
    80001f04:	67c8                	ld	a0,136(a5)
    80001f06:	b7dd                	j	80001eec <argraw+0x30>
    return p->trapframe->a4;
    80001f08:	6d3c                	ld	a5,88(a0)
    80001f0a:	6bc8                	ld	a0,144(a5)
    80001f0c:	b7c5                	j	80001eec <argraw+0x30>
    return p->trapframe->a5;
    80001f0e:	6d3c                	ld	a5,88(a0)
    80001f10:	6fc8                	ld	a0,152(a5)
    80001f12:	bfe9                	j	80001eec <argraw+0x30>
  panic("argraw");
    80001f14:	00006517          	auipc	a0,0x6
    80001f18:	4bc50513          	addi	a0,a0,1212 # 800083d0 <states.0+0x148>
    80001f1c:	00004097          	auipc	ra,0x4
    80001f20:	cd2080e7          	jalr	-814(ra) # 80005bee <panic>

0000000080001f24 <fetchaddr>:
{
    80001f24:	1101                	addi	sp,sp,-32
    80001f26:	ec06                	sd	ra,24(sp)
    80001f28:	e822                	sd	s0,16(sp)
    80001f2a:	e426                	sd	s1,8(sp)
    80001f2c:	e04a                	sd	s2,0(sp)
    80001f2e:	1000                	addi	s0,sp,32
    80001f30:	84aa                	mv	s1,a0
    80001f32:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	f76080e7          	jalr	-138(ra) # 80000eaa <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f3c:	653c                	ld	a5,72(a0)
    80001f3e:	02f4f863          	bgeu	s1,a5,80001f6e <fetchaddr+0x4a>
    80001f42:	00848713          	addi	a4,s1,8
    80001f46:	02e7e663          	bltu	a5,a4,80001f72 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f4a:	46a1                	li	a3,8
    80001f4c:	8626                	mv	a2,s1
    80001f4e:	85ca                	mv	a1,s2
    80001f50:	6928                	ld	a0,80(a0)
    80001f52:	fffff097          	auipc	ra,0xfffff
    80001f56:	ca0080e7          	jalr	-864(ra) # 80000bf2 <copyin>
    80001f5a:	00a03533          	snez	a0,a0
    80001f5e:	40a00533          	neg	a0,a0
}
    80001f62:	60e2                	ld	ra,24(sp)
    80001f64:	6442                	ld	s0,16(sp)
    80001f66:	64a2                	ld	s1,8(sp)
    80001f68:	6902                	ld	s2,0(sp)
    80001f6a:	6105                	addi	sp,sp,32
    80001f6c:	8082                	ret
    return -1;
    80001f6e:	557d                	li	a0,-1
    80001f70:	bfcd                	j	80001f62 <fetchaddr+0x3e>
    80001f72:	557d                	li	a0,-1
    80001f74:	b7fd                	j	80001f62 <fetchaddr+0x3e>

0000000080001f76 <fetchstr>:
{
    80001f76:	7179                	addi	sp,sp,-48
    80001f78:	f406                	sd	ra,40(sp)
    80001f7a:	f022                	sd	s0,32(sp)
    80001f7c:	ec26                	sd	s1,24(sp)
    80001f7e:	e84a                	sd	s2,16(sp)
    80001f80:	e44e                	sd	s3,8(sp)
    80001f82:	1800                	addi	s0,sp,48
    80001f84:	892a                	mv	s2,a0
    80001f86:	84ae                	mv	s1,a1
    80001f88:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	f20080e7          	jalr	-224(ra) # 80000eaa <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f92:	86ce                	mv	a3,s3
    80001f94:	864a                	mv	a2,s2
    80001f96:	85a6                	mv	a1,s1
    80001f98:	6928                	ld	a0,80(a0)
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	ce6080e7          	jalr	-794(ra) # 80000c80 <copyinstr>
    80001fa2:	00054e63          	bltz	a0,80001fbe <fetchstr+0x48>
  return strlen(buf);
    80001fa6:	8526                	mv	a0,s1
    80001fa8:	ffffe097          	auipc	ra,0xffffe
    80001fac:	34c080e7          	jalr	844(ra) # 800002f4 <strlen>
}
    80001fb0:	70a2                	ld	ra,40(sp)
    80001fb2:	7402                	ld	s0,32(sp)
    80001fb4:	64e2                	ld	s1,24(sp)
    80001fb6:	6942                	ld	s2,16(sp)
    80001fb8:	69a2                	ld	s3,8(sp)
    80001fba:	6145                	addi	sp,sp,48
    80001fbc:	8082                	ret
    return -1;
    80001fbe:	557d                	li	a0,-1
    80001fc0:	bfc5                	j	80001fb0 <fetchstr+0x3a>

0000000080001fc2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001fc2:	1101                	addi	sp,sp,-32
    80001fc4:	ec06                	sd	ra,24(sp)
    80001fc6:	e822                	sd	s0,16(sp)
    80001fc8:	e426                	sd	s1,8(sp)
    80001fca:	1000                	addi	s0,sp,32
    80001fcc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fce:	00000097          	auipc	ra,0x0
    80001fd2:	eee080e7          	jalr	-274(ra) # 80001ebc <argraw>
    80001fd6:	c088                	sw	a0,0(s1)
}
    80001fd8:	60e2                	ld	ra,24(sp)
    80001fda:	6442                	ld	s0,16(sp)
    80001fdc:	64a2                	ld	s1,8(sp)
    80001fde:	6105                	addi	sp,sp,32
    80001fe0:	8082                	ret

0000000080001fe2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001fe2:	1101                	addi	sp,sp,-32
    80001fe4:	ec06                	sd	ra,24(sp)
    80001fe6:	e822                	sd	s0,16(sp)
    80001fe8:	e426                	sd	s1,8(sp)
    80001fea:	1000                	addi	s0,sp,32
    80001fec:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fee:	00000097          	auipc	ra,0x0
    80001ff2:	ece080e7          	jalr	-306(ra) # 80001ebc <argraw>
    80001ff6:	e088                	sd	a0,0(s1)
}
    80001ff8:	60e2                	ld	ra,24(sp)
    80001ffa:	6442                	ld	s0,16(sp)
    80001ffc:	64a2                	ld	s1,8(sp)
    80001ffe:	6105                	addi	sp,sp,32
    80002000:	8082                	ret

0000000080002002 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002002:	7179                	addi	sp,sp,-48
    80002004:	f406                	sd	ra,40(sp)
    80002006:	f022                	sd	s0,32(sp)
    80002008:	ec26                	sd	s1,24(sp)
    8000200a:	e84a                	sd	s2,16(sp)
    8000200c:	1800                	addi	s0,sp,48
    8000200e:	84ae                	mv	s1,a1
    80002010:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002012:	fd840593          	addi	a1,s0,-40
    80002016:	00000097          	auipc	ra,0x0
    8000201a:	fcc080e7          	jalr	-52(ra) # 80001fe2 <argaddr>
  return fetchstr(addr, buf, max);
    8000201e:	864a                	mv	a2,s2
    80002020:	85a6                	mv	a1,s1
    80002022:	fd843503          	ld	a0,-40(s0)
    80002026:	00000097          	auipc	ra,0x0
    8000202a:	f50080e7          	jalr	-176(ra) # 80001f76 <fetchstr>
}
    8000202e:	70a2                	ld	ra,40(sp)
    80002030:	7402                	ld	s0,32(sp)
    80002032:	64e2                	ld	s1,24(sp)
    80002034:	6942                	ld	s2,16(sp)
    80002036:	6145                	addi	sp,sp,48
    80002038:	8082                	ret

000000008000203a <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000203a:	1101                	addi	sp,sp,-32
    8000203c:	ec06                	sd	ra,24(sp)
    8000203e:	e822                	sd	s0,16(sp)
    80002040:	e426                	sd	s1,8(sp)
    80002042:	e04a                	sd	s2,0(sp)
    80002044:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	e64080e7          	jalr	-412(ra) # 80000eaa <myproc>
    8000204e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002050:	05853903          	ld	s2,88(a0)
    80002054:	0a893783          	ld	a5,168(s2)
    80002058:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000205c:	37fd                	addiw	a5,a5,-1
    8000205e:	4751                	li	a4,20
    80002060:	00f76f63          	bltu	a4,a5,8000207e <syscall+0x44>
    80002064:	00369713          	slli	a4,a3,0x3
    80002068:	00006797          	auipc	a5,0x6
    8000206c:	3a878793          	addi	a5,a5,936 # 80008410 <syscalls>
    80002070:	97ba                	add	a5,a5,a4
    80002072:	639c                	ld	a5,0(a5)
    80002074:	c789                	beqz	a5,8000207e <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002076:	9782                	jalr	a5
    80002078:	06a93823          	sd	a0,112(s2)
    8000207c:	a839                	j	8000209a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000207e:	15848613          	addi	a2,s1,344
    80002082:	588c                	lw	a1,48(s1)
    80002084:	00006517          	auipc	a0,0x6
    80002088:	35450513          	addi	a0,a0,852 # 800083d8 <states.0+0x150>
    8000208c:	00004097          	auipc	ra,0x4
    80002090:	bac080e7          	jalr	-1108(ra) # 80005c38 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002094:	6cbc                	ld	a5,88(s1)
    80002096:	577d                	li	a4,-1
    80002098:	fbb8                	sd	a4,112(a5)
  }
}
    8000209a:	60e2                	ld	ra,24(sp)
    8000209c:	6442                	ld	s0,16(sp)
    8000209e:	64a2                	ld	s1,8(sp)
    800020a0:	6902                	ld	s2,0(sp)
    800020a2:	6105                	addi	sp,sp,32
    800020a4:	8082                	ret

00000000800020a6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020a6:	1101                	addi	sp,sp,-32
    800020a8:	ec06                	sd	ra,24(sp)
    800020aa:	e822                	sd	s0,16(sp)
    800020ac:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800020ae:	fec40593          	addi	a1,s0,-20
    800020b2:	4501                	li	a0,0
    800020b4:	00000097          	auipc	ra,0x0
    800020b8:	f0e080e7          	jalr	-242(ra) # 80001fc2 <argint>
  exit(n);
    800020bc:	fec42503          	lw	a0,-20(s0)
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	5ca080e7          	jalr	1482(ra) # 8000168a <exit>
  return 0;  // not reached
}
    800020c8:	4501                	li	a0,0
    800020ca:	60e2                	ld	ra,24(sp)
    800020cc:	6442                	ld	s0,16(sp)
    800020ce:	6105                	addi	sp,sp,32
    800020d0:	8082                	ret

00000000800020d2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020d2:	1141                	addi	sp,sp,-16
    800020d4:	e406                	sd	ra,8(sp)
    800020d6:	e022                	sd	s0,0(sp)
    800020d8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020da:	fffff097          	auipc	ra,0xfffff
    800020de:	dd0080e7          	jalr	-560(ra) # 80000eaa <myproc>
}
    800020e2:	5908                	lw	a0,48(a0)
    800020e4:	60a2                	ld	ra,8(sp)
    800020e6:	6402                	ld	s0,0(sp)
    800020e8:	0141                	addi	sp,sp,16
    800020ea:	8082                	ret

00000000800020ec <sys_fork>:

uint64
sys_fork(void)
{
    800020ec:	1141                	addi	sp,sp,-16
    800020ee:	e406                	sd	ra,8(sp)
    800020f0:	e022                	sd	s0,0(sp)
    800020f2:	0800                	addi	s0,sp,16
  return fork();
    800020f4:	fffff097          	auipc	ra,0xfffff
    800020f8:	170080e7          	jalr	368(ra) # 80001264 <fork>
}
    800020fc:	60a2                	ld	ra,8(sp)
    800020fe:	6402                	ld	s0,0(sp)
    80002100:	0141                	addi	sp,sp,16
    80002102:	8082                	ret

0000000080002104 <sys_wait>:

uint64
sys_wait(void)
{
    80002104:	1101                	addi	sp,sp,-32
    80002106:	ec06                	sd	ra,24(sp)
    80002108:	e822                	sd	s0,16(sp)
    8000210a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000210c:	fe840593          	addi	a1,s0,-24
    80002110:	4501                	li	a0,0
    80002112:	00000097          	auipc	ra,0x0
    80002116:	ed0080e7          	jalr	-304(ra) # 80001fe2 <argaddr>
  return wait(p);
    8000211a:	fe843503          	ld	a0,-24(s0)
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	712080e7          	jalr	1810(ra) # 80001830 <wait>
}
    80002126:	60e2                	ld	ra,24(sp)
    80002128:	6442                	ld	s0,16(sp)
    8000212a:	6105                	addi	sp,sp,32
    8000212c:	8082                	ret

000000008000212e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000212e:	7179                	addi	sp,sp,-48
    80002130:	f406                	sd	ra,40(sp)
    80002132:	f022                	sd	s0,32(sp)
    80002134:	ec26                	sd	s1,24(sp)
    80002136:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002138:	fdc40593          	addi	a1,s0,-36
    8000213c:	4501                	li	a0,0
    8000213e:	00000097          	auipc	ra,0x0
    80002142:	e84080e7          	jalr	-380(ra) # 80001fc2 <argint>
  addr = myproc()->sz;
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	d64080e7          	jalr	-668(ra) # 80000eaa <myproc>
    8000214e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002150:	fdc42503          	lw	a0,-36(s0)
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	0b4080e7          	jalr	180(ra) # 80001208 <growproc>
    8000215c:	00054863          	bltz	a0,8000216c <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002160:	8526                	mv	a0,s1
    80002162:	70a2                	ld	ra,40(sp)
    80002164:	7402                	ld	s0,32(sp)
    80002166:	64e2                	ld	s1,24(sp)
    80002168:	6145                	addi	sp,sp,48
    8000216a:	8082                	ret
    return -1;
    8000216c:	54fd                	li	s1,-1
    8000216e:	bfcd                	j	80002160 <sys_sbrk+0x32>

0000000080002170 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002170:	7139                	addi	sp,sp,-64
    80002172:	fc06                	sd	ra,56(sp)
    80002174:	f822                	sd	s0,48(sp)
    80002176:	f426                	sd	s1,40(sp)
    80002178:	f04a                	sd	s2,32(sp)
    8000217a:	ec4e                	sd	s3,24(sp)
    8000217c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000217e:	fcc40593          	addi	a1,s0,-52
    80002182:	4501                	li	a0,0
    80002184:	00000097          	auipc	ra,0x0
    80002188:	e3e080e7          	jalr	-450(ra) # 80001fc2 <argint>
  if(n < 0)
    8000218c:	fcc42783          	lw	a5,-52(s0)
    80002190:	0607cf63          	bltz	a5,8000220e <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002194:	0000c517          	auipc	a0,0xc
    80002198:	5bc50513          	addi	a0,a0,1468 # 8000e750 <tickslock>
    8000219c:	00004097          	auipc	ra,0x4
    800021a0:	f8e080e7          	jalr	-114(ra) # 8000612a <acquire>
  ticks0 = ticks;
    800021a4:	00006917          	auipc	s2,0x6
    800021a8:	74492903          	lw	s2,1860(s2) # 800088e8 <ticks>
  while(ticks - ticks0 < n){
    800021ac:	fcc42783          	lw	a5,-52(s0)
    800021b0:	cf9d                	beqz	a5,800021ee <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021b2:	0000c997          	auipc	s3,0xc
    800021b6:	59e98993          	addi	s3,s3,1438 # 8000e750 <tickslock>
    800021ba:	00006497          	auipc	s1,0x6
    800021be:	72e48493          	addi	s1,s1,1838 # 800088e8 <ticks>
    if(killed(myproc())){
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	ce8080e7          	jalr	-792(ra) # 80000eaa <myproc>
    800021ca:	fffff097          	auipc	ra,0xfffff
    800021ce:	634080e7          	jalr	1588(ra) # 800017fe <killed>
    800021d2:	e129                	bnez	a0,80002214 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800021d4:	85ce                	mv	a1,s3
    800021d6:	8526                	mv	a0,s1
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	37e080e7          	jalr	894(ra) # 80001556 <sleep>
  while(ticks - ticks0 < n){
    800021e0:	409c                	lw	a5,0(s1)
    800021e2:	412787bb          	subw	a5,a5,s2
    800021e6:	fcc42703          	lw	a4,-52(s0)
    800021ea:	fce7ece3          	bltu	a5,a4,800021c2 <sys_sleep+0x52>
  }
  release(&tickslock);
    800021ee:	0000c517          	auipc	a0,0xc
    800021f2:	56250513          	addi	a0,a0,1378 # 8000e750 <tickslock>
    800021f6:	00004097          	auipc	ra,0x4
    800021fa:	fe8080e7          	jalr	-24(ra) # 800061de <release>
  return 0;
    800021fe:	4501                	li	a0,0
}
    80002200:	70e2                	ld	ra,56(sp)
    80002202:	7442                	ld	s0,48(sp)
    80002204:	74a2                	ld	s1,40(sp)
    80002206:	7902                	ld	s2,32(sp)
    80002208:	69e2                	ld	s3,24(sp)
    8000220a:	6121                	addi	sp,sp,64
    8000220c:	8082                	ret
    n = 0;
    8000220e:	fc042623          	sw	zero,-52(s0)
    80002212:	b749                	j	80002194 <sys_sleep+0x24>
      release(&tickslock);
    80002214:	0000c517          	auipc	a0,0xc
    80002218:	53c50513          	addi	a0,a0,1340 # 8000e750 <tickslock>
    8000221c:	00004097          	auipc	ra,0x4
    80002220:	fc2080e7          	jalr	-62(ra) # 800061de <release>
      return -1;
    80002224:	557d                	li	a0,-1
    80002226:	bfe9                	j	80002200 <sys_sleep+0x90>

0000000080002228 <sys_kill>:

uint64
sys_kill(void)
{
    80002228:	1101                	addi	sp,sp,-32
    8000222a:	ec06                	sd	ra,24(sp)
    8000222c:	e822                	sd	s0,16(sp)
    8000222e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002230:	fec40593          	addi	a1,s0,-20
    80002234:	4501                	li	a0,0
    80002236:	00000097          	auipc	ra,0x0
    8000223a:	d8c080e7          	jalr	-628(ra) # 80001fc2 <argint>
  return kill(pid);
    8000223e:	fec42503          	lw	a0,-20(s0)
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	51e080e7          	jalr	1310(ra) # 80001760 <kill>
}
    8000224a:	60e2                	ld	ra,24(sp)
    8000224c:	6442                	ld	s0,16(sp)
    8000224e:	6105                	addi	sp,sp,32
    80002250:	8082                	ret

0000000080002252 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002252:	1101                	addi	sp,sp,-32
    80002254:	ec06                	sd	ra,24(sp)
    80002256:	e822                	sd	s0,16(sp)
    80002258:	e426                	sd	s1,8(sp)
    8000225a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000225c:	0000c517          	auipc	a0,0xc
    80002260:	4f450513          	addi	a0,a0,1268 # 8000e750 <tickslock>
    80002264:	00004097          	auipc	ra,0x4
    80002268:	ec6080e7          	jalr	-314(ra) # 8000612a <acquire>
  xticks = ticks;
    8000226c:	00006497          	auipc	s1,0x6
    80002270:	67c4a483          	lw	s1,1660(s1) # 800088e8 <ticks>
  release(&tickslock);
    80002274:	0000c517          	auipc	a0,0xc
    80002278:	4dc50513          	addi	a0,a0,1244 # 8000e750 <tickslock>
    8000227c:	00004097          	auipc	ra,0x4
    80002280:	f62080e7          	jalr	-158(ra) # 800061de <release>
  return xticks;
}
    80002284:	02049513          	slli	a0,s1,0x20
    80002288:	9101                	srli	a0,a0,0x20
    8000228a:	60e2                	ld	ra,24(sp)
    8000228c:	6442                	ld	s0,16(sp)
    8000228e:	64a2                	ld	s1,8(sp)
    80002290:	6105                	addi	sp,sp,32
    80002292:	8082                	ret

0000000080002294 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002294:	7179                	addi	sp,sp,-48
    80002296:	f406                	sd	ra,40(sp)
    80002298:	f022                	sd	s0,32(sp)
    8000229a:	ec26                	sd	s1,24(sp)
    8000229c:	e84a                	sd	s2,16(sp)
    8000229e:	e44e                	sd	s3,8(sp)
    800022a0:	e052                	sd	s4,0(sp)
    800022a2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022a4:	00006597          	auipc	a1,0x6
    800022a8:	21c58593          	addi	a1,a1,540 # 800084c0 <syscalls+0xb0>
    800022ac:	0000c517          	auipc	a0,0xc
    800022b0:	4bc50513          	addi	a0,a0,1212 # 8000e768 <bcache>
    800022b4:	00004097          	auipc	ra,0x4
    800022b8:	de6080e7          	jalr	-538(ra) # 8000609a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022bc:	00014797          	auipc	a5,0x14
    800022c0:	4ac78793          	addi	a5,a5,1196 # 80016768 <bcache+0x8000>
    800022c4:	00014717          	auipc	a4,0x14
    800022c8:	70c70713          	addi	a4,a4,1804 # 800169d0 <bcache+0x8268>
    800022cc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022d0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022d4:	0000c497          	auipc	s1,0xc
    800022d8:	4ac48493          	addi	s1,s1,1196 # 8000e780 <bcache+0x18>
    b->next = bcache.head.next;
    800022dc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022de:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022e0:	00006a17          	auipc	s4,0x6
    800022e4:	1e8a0a13          	addi	s4,s4,488 # 800084c8 <syscalls+0xb8>
    b->next = bcache.head.next;
    800022e8:	2b893783          	ld	a5,696(s2)
    800022ec:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022ee:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022f2:	85d2                	mv	a1,s4
    800022f4:	01048513          	addi	a0,s1,16
    800022f8:	00001097          	auipc	ra,0x1
    800022fc:	4c4080e7          	jalr	1220(ra) # 800037bc <initsleeplock>
    bcache.head.next->prev = b;
    80002300:	2b893783          	ld	a5,696(s2)
    80002304:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002306:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000230a:	45848493          	addi	s1,s1,1112
    8000230e:	fd349de3          	bne	s1,s3,800022e8 <binit+0x54>
  }
}
    80002312:	70a2                	ld	ra,40(sp)
    80002314:	7402                	ld	s0,32(sp)
    80002316:	64e2                	ld	s1,24(sp)
    80002318:	6942                	ld	s2,16(sp)
    8000231a:	69a2                	ld	s3,8(sp)
    8000231c:	6a02                	ld	s4,0(sp)
    8000231e:	6145                	addi	sp,sp,48
    80002320:	8082                	ret

0000000080002322 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002322:	7179                	addi	sp,sp,-48
    80002324:	f406                	sd	ra,40(sp)
    80002326:	f022                	sd	s0,32(sp)
    80002328:	ec26                	sd	s1,24(sp)
    8000232a:	e84a                	sd	s2,16(sp)
    8000232c:	e44e                	sd	s3,8(sp)
    8000232e:	1800                	addi	s0,sp,48
    80002330:	892a                	mv	s2,a0
    80002332:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002334:	0000c517          	auipc	a0,0xc
    80002338:	43450513          	addi	a0,a0,1076 # 8000e768 <bcache>
    8000233c:	00004097          	auipc	ra,0x4
    80002340:	dee080e7          	jalr	-530(ra) # 8000612a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002344:	00014497          	auipc	s1,0x14
    80002348:	6dc4b483          	ld	s1,1756(s1) # 80016a20 <bcache+0x82b8>
    8000234c:	00014797          	auipc	a5,0x14
    80002350:	68478793          	addi	a5,a5,1668 # 800169d0 <bcache+0x8268>
    80002354:	02f48f63          	beq	s1,a5,80002392 <bread+0x70>
    80002358:	873e                	mv	a4,a5
    8000235a:	a021                	j	80002362 <bread+0x40>
    8000235c:	68a4                	ld	s1,80(s1)
    8000235e:	02e48a63          	beq	s1,a4,80002392 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002362:	449c                	lw	a5,8(s1)
    80002364:	ff279ce3          	bne	a5,s2,8000235c <bread+0x3a>
    80002368:	44dc                	lw	a5,12(s1)
    8000236a:	ff3799e3          	bne	a5,s3,8000235c <bread+0x3a>
      b->refcnt++;
    8000236e:	40bc                	lw	a5,64(s1)
    80002370:	2785                	addiw	a5,a5,1
    80002372:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002374:	0000c517          	auipc	a0,0xc
    80002378:	3f450513          	addi	a0,a0,1012 # 8000e768 <bcache>
    8000237c:	00004097          	auipc	ra,0x4
    80002380:	e62080e7          	jalr	-414(ra) # 800061de <release>
      acquiresleep(&b->lock);
    80002384:	01048513          	addi	a0,s1,16
    80002388:	00001097          	auipc	ra,0x1
    8000238c:	46e080e7          	jalr	1134(ra) # 800037f6 <acquiresleep>
      return b;
    80002390:	a8b9                	j	800023ee <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002392:	00014497          	auipc	s1,0x14
    80002396:	6864b483          	ld	s1,1670(s1) # 80016a18 <bcache+0x82b0>
    8000239a:	00014797          	auipc	a5,0x14
    8000239e:	63678793          	addi	a5,a5,1590 # 800169d0 <bcache+0x8268>
    800023a2:	00f48863          	beq	s1,a5,800023b2 <bread+0x90>
    800023a6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023a8:	40bc                	lw	a5,64(s1)
    800023aa:	cf81                	beqz	a5,800023c2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023ac:	64a4                	ld	s1,72(s1)
    800023ae:	fee49de3          	bne	s1,a4,800023a8 <bread+0x86>
  panic("bget: no buffers");
    800023b2:	00006517          	auipc	a0,0x6
    800023b6:	11e50513          	addi	a0,a0,286 # 800084d0 <syscalls+0xc0>
    800023ba:	00004097          	auipc	ra,0x4
    800023be:	834080e7          	jalr	-1996(ra) # 80005bee <panic>
      b->dev = dev;
    800023c2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023c6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023ca:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023ce:	4785                	li	a5,1
    800023d0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023d2:	0000c517          	auipc	a0,0xc
    800023d6:	39650513          	addi	a0,a0,918 # 8000e768 <bcache>
    800023da:	00004097          	auipc	ra,0x4
    800023de:	e04080e7          	jalr	-508(ra) # 800061de <release>
      acquiresleep(&b->lock);
    800023e2:	01048513          	addi	a0,s1,16
    800023e6:	00001097          	auipc	ra,0x1
    800023ea:	410080e7          	jalr	1040(ra) # 800037f6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023ee:	409c                	lw	a5,0(s1)
    800023f0:	cb89                	beqz	a5,80002402 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023f2:	8526                	mv	a0,s1
    800023f4:	70a2                	ld	ra,40(sp)
    800023f6:	7402                	ld	s0,32(sp)
    800023f8:	64e2                	ld	s1,24(sp)
    800023fa:	6942                	ld	s2,16(sp)
    800023fc:	69a2                	ld	s3,8(sp)
    800023fe:	6145                	addi	sp,sp,48
    80002400:	8082                	ret
    virtio_disk_rw(b, 0);
    80002402:	4581                	li	a1,0
    80002404:	8526                	mv	a0,s1
    80002406:	00003097          	auipc	ra,0x3
    8000240a:	fde080e7          	jalr	-34(ra) # 800053e4 <virtio_disk_rw>
    b->valid = 1;
    8000240e:	4785                	li	a5,1
    80002410:	c09c                	sw	a5,0(s1)
  return b;
    80002412:	b7c5                	j	800023f2 <bread+0xd0>

0000000080002414 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002414:	1101                	addi	sp,sp,-32
    80002416:	ec06                	sd	ra,24(sp)
    80002418:	e822                	sd	s0,16(sp)
    8000241a:	e426                	sd	s1,8(sp)
    8000241c:	1000                	addi	s0,sp,32
    8000241e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002420:	0541                	addi	a0,a0,16
    80002422:	00001097          	auipc	ra,0x1
    80002426:	46e080e7          	jalr	1134(ra) # 80003890 <holdingsleep>
    8000242a:	cd01                	beqz	a0,80002442 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000242c:	4585                	li	a1,1
    8000242e:	8526                	mv	a0,s1
    80002430:	00003097          	auipc	ra,0x3
    80002434:	fb4080e7          	jalr	-76(ra) # 800053e4 <virtio_disk_rw>
}
    80002438:	60e2                	ld	ra,24(sp)
    8000243a:	6442                	ld	s0,16(sp)
    8000243c:	64a2                	ld	s1,8(sp)
    8000243e:	6105                	addi	sp,sp,32
    80002440:	8082                	ret
    panic("bwrite");
    80002442:	00006517          	auipc	a0,0x6
    80002446:	0a650513          	addi	a0,a0,166 # 800084e8 <syscalls+0xd8>
    8000244a:	00003097          	auipc	ra,0x3
    8000244e:	7a4080e7          	jalr	1956(ra) # 80005bee <panic>

0000000080002452 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002452:	1101                	addi	sp,sp,-32
    80002454:	ec06                	sd	ra,24(sp)
    80002456:	e822                	sd	s0,16(sp)
    80002458:	e426                	sd	s1,8(sp)
    8000245a:	e04a                	sd	s2,0(sp)
    8000245c:	1000                	addi	s0,sp,32
    8000245e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002460:	01050913          	addi	s2,a0,16
    80002464:	854a                	mv	a0,s2
    80002466:	00001097          	auipc	ra,0x1
    8000246a:	42a080e7          	jalr	1066(ra) # 80003890 <holdingsleep>
    8000246e:	c92d                	beqz	a0,800024e0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002470:	854a                	mv	a0,s2
    80002472:	00001097          	auipc	ra,0x1
    80002476:	3da080e7          	jalr	986(ra) # 8000384c <releasesleep>

  acquire(&bcache.lock);
    8000247a:	0000c517          	auipc	a0,0xc
    8000247e:	2ee50513          	addi	a0,a0,750 # 8000e768 <bcache>
    80002482:	00004097          	auipc	ra,0x4
    80002486:	ca8080e7          	jalr	-856(ra) # 8000612a <acquire>
  b->refcnt--;
    8000248a:	40bc                	lw	a5,64(s1)
    8000248c:	37fd                	addiw	a5,a5,-1
    8000248e:	0007871b          	sext.w	a4,a5
    80002492:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002494:	eb05                	bnez	a4,800024c4 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002496:	68bc                	ld	a5,80(s1)
    80002498:	64b8                	ld	a4,72(s1)
    8000249a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000249c:	64bc                	ld	a5,72(s1)
    8000249e:	68b8                	ld	a4,80(s1)
    800024a0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024a2:	00014797          	auipc	a5,0x14
    800024a6:	2c678793          	addi	a5,a5,710 # 80016768 <bcache+0x8000>
    800024aa:	2b87b703          	ld	a4,696(a5)
    800024ae:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024b0:	00014717          	auipc	a4,0x14
    800024b4:	52070713          	addi	a4,a4,1312 # 800169d0 <bcache+0x8268>
    800024b8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024ba:	2b87b703          	ld	a4,696(a5)
    800024be:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024c0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024c4:	0000c517          	auipc	a0,0xc
    800024c8:	2a450513          	addi	a0,a0,676 # 8000e768 <bcache>
    800024cc:	00004097          	auipc	ra,0x4
    800024d0:	d12080e7          	jalr	-750(ra) # 800061de <release>
}
    800024d4:	60e2                	ld	ra,24(sp)
    800024d6:	6442                	ld	s0,16(sp)
    800024d8:	64a2                	ld	s1,8(sp)
    800024da:	6902                	ld	s2,0(sp)
    800024dc:	6105                	addi	sp,sp,32
    800024de:	8082                	ret
    panic("brelse");
    800024e0:	00006517          	auipc	a0,0x6
    800024e4:	01050513          	addi	a0,a0,16 # 800084f0 <syscalls+0xe0>
    800024e8:	00003097          	auipc	ra,0x3
    800024ec:	706080e7          	jalr	1798(ra) # 80005bee <panic>

00000000800024f0 <bpin>:

void
bpin(struct buf *b) {
    800024f0:	1101                	addi	sp,sp,-32
    800024f2:	ec06                	sd	ra,24(sp)
    800024f4:	e822                	sd	s0,16(sp)
    800024f6:	e426                	sd	s1,8(sp)
    800024f8:	1000                	addi	s0,sp,32
    800024fa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024fc:	0000c517          	auipc	a0,0xc
    80002500:	26c50513          	addi	a0,a0,620 # 8000e768 <bcache>
    80002504:	00004097          	auipc	ra,0x4
    80002508:	c26080e7          	jalr	-986(ra) # 8000612a <acquire>
  b->refcnt++;
    8000250c:	40bc                	lw	a5,64(s1)
    8000250e:	2785                	addiw	a5,a5,1
    80002510:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002512:	0000c517          	auipc	a0,0xc
    80002516:	25650513          	addi	a0,a0,598 # 8000e768 <bcache>
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	cc4080e7          	jalr	-828(ra) # 800061de <release>
}
    80002522:	60e2                	ld	ra,24(sp)
    80002524:	6442                	ld	s0,16(sp)
    80002526:	64a2                	ld	s1,8(sp)
    80002528:	6105                	addi	sp,sp,32
    8000252a:	8082                	ret

000000008000252c <bunpin>:

void
bunpin(struct buf *b) {
    8000252c:	1101                	addi	sp,sp,-32
    8000252e:	ec06                	sd	ra,24(sp)
    80002530:	e822                	sd	s0,16(sp)
    80002532:	e426                	sd	s1,8(sp)
    80002534:	1000                	addi	s0,sp,32
    80002536:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002538:	0000c517          	auipc	a0,0xc
    8000253c:	23050513          	addi	a0,a0,560 # 8000e768 <bcache>
    80002540:	00004097          	auipc	ra,0x4
    80002544:	bea080e7          	jalr	-1046(ra) # 8000612a <acquire>
  b->refcnt--;
    80002548:	40bc                	lw	a5,64(s1)
    8000254a:	37fd                	addiw	a5,a5,-1
    8000254c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000254e:	0000c517          	auipc	a0,0xc
    80002552:	21a50513          	addi	a0,a0,538 # 8000e768 <bcache>
    80002556:	00004097          	auipc	ra,0x4
    8000255a:	c88080e7          	jalr	-888(ra) # 800061de <release>
}
    8000255e:	60e2                	ld	ra,24(sp)
    80002560:	6442                	ld	s0,16(sp)
    80002562:	64a2                	ld	s1,8(sp)
    80002564:	6105                	addi	sp,sp,32
    80002566:	8082                	ret

0000000080002568 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002568:	1101                	addi	sp,sp,-32
    8000256a:	ec06                	sd	ra,24(sp)
    8000256c:	e822                	sd	s0,16(sp)
    8000256e:	e426                	sd	s1,8(sp)
    80002570:	e04a                	sd	s2,0(sp)
    80002572:	1000                	addi	s0,sp,32
    80002574:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002576:	00d5d59b          	srliw	a1,a1,0xd
    8000257a:	00015797          	auipc	a5,0x15
    8000257e:	8ca7a783          	lw	a5,-1846(a5) # 80016e44 <sb+0x1c>
    80002582:	9dbd                	addw	a1,a1,a5
    80002584:	00000097          	auipc	ra,0x0
    80002588:	d9e080e7          	jalr	-610(ra) # 80002322 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000258c:	0074f713          	andi	a4,s1,7
    80002590:	4785                	li	a5,1
    80002592:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002596:	14ce                	slli	s1,s1,0x33
    80002598:	90d9                	srli	s1,s1,0x36
    8000259a:	00950733          	add	a4,a0,s1
    8000259e:	05874703          	lbu	a4,88(a4)
    800025a2:	00e7f6b3          	and	a3,a5,a4
    800025a6:	c69d                	beqz	a3,800025d4 <bfree+0x6c>
    800025a8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025aa:	94aa                	add	s1,s1,a0
    800025ac:	fff7c793          	not	a5,a5
    800025b0:	8ff9                	and	a5,a5,a4
    800025b2:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800025b6:	00001097          	auipc	ra,0x1
    800025ba:	120080e7          	jalr	288(ra) # 800036d6 <log_write>
  brelse(bp);
    800025be:	854a                	mv	a0,s2
    800025c0:	00000097          	auipc	ra,0x0
    800025c4:	e92080e7          	jalr	-366(ra) # 80002452 <brelse>
}
    800025c8:	60e2                	ld	ra,24(sp)
    800025ca:	6442                	ld	s0,16(sp)
    800025cc:	64a2                	ld	s1,8(sp)
    800025ce:	6902                	ld	s2,0(sp)
    800025d0:	6105                	addi	sp,sp,32
    800025d2:	8082                	ret
    panic("freeing free block");
    800025d4:	00006517          	auipc	a0,0x6
    800025d8:	f2450513          	addi	a0,a0,-220 # 800084f8 <syscalls+0xe8>
    800025dc:	00003097          	auipc	ra,0x3
    800025e0:	612080e7          	jalr	1554(ra) # 80005bee <panic>

00000000800025e4 <balloc>:
{
    800025e4:	711d                	addi	sp,sp,-96
    800025e6:	ec86                	sd	ra,88(sp)
    800025e8:	e8a2                	sd	s0,80(sp)
    800025ea:	e4a6                	sd	s1,72(sp)
    800025ec:	e0ca                	sd	s2,64(sp)
    800025ee:	fc4e                	sd	s3,56(sp)
    800025f0:	f852                	sd	s4,48(sp)
    800025f2:	f456                	sd	s5,40(sp)
    800025f4:	f05a                	sd	s6,32(sp)
    800025f6:	ec5e                	sd	s7,24(sp)
    800025f8:	e862                	sd	s8,16(sp)
    800025fa:	e466                	sd	s9,8(sp)
    800025fc:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025fe:	00015797          	auipc	a5,0x15
    80002602:	82e7a783          	lw	a5,-2002(a5) # 80016e2c <sb+0x4>
    80002606:	10078163          	beqz	a5,80002708 <balloc+0x124>
    8000260a:	8baa                	mv	s7,a0
    8000260c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000260e:	00015b17          	auipc	s6,0x15
    80002612:	81ab0b13          	addi	s6,s6,-2022 # 80016e28 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002616:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002618:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000261a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000261c:	6c89                	lui	s9,0x2
    8000261e:	a061                	j	800026a6 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002620:	974a                	add	a4,a4,s2
    80002622:	8fd5                	or	a5,a5,a3
    80002624:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002628:	854a                	mv	a0,s2
    8000262a:	00001097          	auipc	ra,0x1
    8000262e:	0ac080e7          	jalr	172(ra) # 800036d6 <log_write>
        brelse(bp);
    80002632:	854a                	mv	a0,s2
    80002634:	00000097          	auipc	ra,0x0
    80002638:	e1e080e7          	jalr	-482(ra) # 80002452 <brelse>
  bp = bread(dev, bno);
    8000263c:	85a6                	mv	a1,s1
    8000263e:	855e                	mv	a0,s7
    80002640:	00000097          	auipc	ra,0x0
    80002644:	ce2080e7          	jalr	-798(ra) # 80002322 <bread>
    80002648:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000264a:	40000613          	li	a2,1024
    8000264e:	4581                	li	a1,0
    80002650:	05850513          	addi	a0,a0,88
    80002654:	ffffe097          	auipc	ra,0xffffe
    80002658:	b24080e7          	jalr	-1244(ra) # 80000178 <memset>
  log_write(bp);
    8000265c:	854a                	mv	a0,s2
    8000265e:	00001097          	auipc	ra,0x1
    80002662:	078080e7          	jalr	120(ra) # 800036d6 <log_write>
  brelse(bp);
    80002666:	854a                	mv	a0,s2
    80002668:	00000097          	auipc	ra,0x0
    8000266c:	dea080e7          	jalr	-534(ra) # 80002452 <brelse>
}
    80002670:	8526                	mv	a0,s1
    80002672:	60e6                	ld	ra,88(sp)
    80002674:	6446                	ld	s0,80(sp)
    80002676:	64a6                	ld	s1,72(sp)
    80002678:	6906                	ld	s2,64(sp)
    8000267a:	79e2                	ld	s3,56(sp)
    8000267c:	7a42                	ld	s4,48(sp)
    8000267e:	7aa2                	ld	s5,40(sp)
    80002680:	7b02                	ld	s6,32(sp)
    80002682:	6be2                	ld	s7,24(sp)
    80002684:	6c42                	ld	s8,16(sp)
    80002686:	6ca2                	ld	s9,8(sp)
    80002688:	6125                	addi	sp,sp,96
    8000268a:	8082                	ret
    brelse(bp);
    8000268c:	854a                	mv	a0,s2
    8000268e:	00000097          	auipc	ra,0x0
    80002692:	dc4080e7          	jalr	-572(ra) # 80002452 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002696:	015c87bb          	addw	a5,s9,s5
    8000269a:	00078a9b          	sext.w	s5,a5
    8000269e:	004b2703          	lw	a4,4(s6)
    800026a2:	06eaf363          	bgeu	s5,a4,80002708 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800026a6:	41fad79b          	sraiw	a5,s5,0x1f
    800026aa:	0137d79b          	srliw	a5,a5,0x13
    800026ae:	015787bb          	addw	a5,a5,s5
    800026b2:	40d7d79b          	sraiw	a5,a5,0xd
    800026b6:	01cb2583          	lw	a1,28(s6)
    800026ba:	9dbd                	addw	a1,a1,a5
    800026bc:	855e                	mv	a0,s7
    800026be:	00000097          	auipc	ra,0x0
    800026c2:	c64080e7          	jalr	-924(ra) # 80002322 <bread>
    800026c6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026c8:	004b2503          	lw	a0,4(s6)
    800026cc:	000a849b          	sext.w	s1,s5
    800026d0:	8662                	mv	a2,s8
    800026d2:	faa4fde3          	bgeu	s1,a0,8000268c <balloc+0xa8>
      m = 1 << (bi % 8);
    800026d6:	41f6579b          	sraiw	a5,a2,0x1f
    800026da:	01d7d69b          	srliw	a3,a5,0x1d
    800026de:	00c6873b          	addw	a4,a3,a2
    800026e2:	00777793          	andi	a5,a4,7
    800026e6:	9f95                	subw	a5,a5,a3
    800026e8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026ec:	4037571b          	sraiw	a4,a4,0x3
    800026f0:	00e906b3          	add	a3,s2,a4
    800026f4:	0586c683          	lbu	a3,88(a3)
    800026f8:	00d7f5b3          	and	a1,a5,a3
    800026fc:	d195                	beqz	a1,80002620 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026fe:	2605                	addiw	a2,a2,1
    80002700:	2485                	addiw	s1,s1,1
    80002702:	fd4618e3          	bne	a2,s4,800026d2 <balloc+0xee>
    80002706:	b759                	j	8000268c <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002708:	00006517          	auipc	a0,0x6
    8000270c:	e0850513          	addi	a0,a0,-504 # 80008510 <syscalls+0x100>
    80002710:	00003097          	auipc	ra,0x3
    80002714:	528080e7          	jalr	1320(ra) # 80005c38 <printf>
  return 0;
    80002718:	4481                	li	s1,0
    8000271a:	bf99                	j	80002670 <balloc+0x8c>

000000008000271c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000271c:	7179                	addi	sp,sp,-48
    8000271e:	f406                	sd	ra,40(sp)
    80002720:	f022                	sd	s0,32(sp)
    80002722:	ec26                	sd	s1,24(sp)
    80002724:	e84a                	sd	s2,16(sp)
    80002726:	e44e                	sd	s3,8(sp)
    80002728:	e052                	sd	s4,0(sp)
    8000272a:	1800                	addi	s0,sp,48
    8000272c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000272e:	47ad                	li	a5,11
    80002730:	02b7e763          	bltu	a5,a1,8000275e <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002734:	02059493          	slli	s1,a1,0x20
    80002738:	9081                	srli	s1,s1,0x20
    8000273a:	048a                	slli	s1,s1,0x2
    8000273c:	94aa                	add	s1,s1,a0
    8000273e:	0504a903          	lw	s2,80(s1)
    80002742:	06091e63          	bnez	s2,800027be <bmap+0xa2>
      addr = balloc(ip->dev);
    80002746:	4108                	lw	a0,0(a0)
    80002748:	00000097          	auipc	ra,0x0
    8000274c:	e9c080e7          	jalr	-356(ra) # 800025e4 <balloc>
    80002750:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002754:	06090563          	beqz	s2,800027be <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002758:	0524a823          	sw	s2,80(s1)
    8000275c:	a08d                	j	800027be <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000275e:	ff45849b          	addiw	s1,a1,-12
    80002762:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002766:	0ff00793          	li	a5,255
    8000276a:	08e7e563          	bltu	a5,a4,800027f4 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000276e:	08052903          	lw	s2,128(a0)
    80002772:	00091d63          	bnez	s2,8000278c <bmap+0x70>
      addr = balloc(ip->dev);
    80002776:	4108                	lw	a0,0(a0)
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	e6c080e7          	jalr	-404(ra) # 800025e4 <balloc>
    80002780:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002784:	02090d63          	beqz	s2,800027be <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002788:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000278c:	85ca                	mv	a1,s2
    8000278e:	0009a503          	lw	a0,0(s3)
    80002792:	00000097          	auipc	ra,0x0
    80002796:	b90080e7          	jalr	-1136(ra) # 80002322 <bread>
    8000279a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000279c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027a0:	02049593          	slli	a1,s1,0x20
    800027a4:	9181                	srli	a1,a1,0x20
    800027a6:	058a                	slli	a1,a1,0x2
    800027a8:	00b784b3          	add	s1,a5,a1
    800027ac:	0004a903          	lw	s2,0(s1)
    800027b0:	02090063          	beqz	s2,800027d0 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800027b4:	8552                	mv	a0,s4
    800027b6:	00000097          	auipc	ra,0x0
    800027ba:	c9c080e7          	jalr	-868(ra) # 80002452 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027be:	854a                	mv	a0,s2
    800027c0:	70a2                	ld	ra,40(sp)
    800027c2:	7402                	ld	s0,32(sp)
    800027c4:	64e2                	ld	s1,24(sp)
    800027c6:	6942                	ld	s2,16(sp)
    800027c8:	69a2                	ld	s3,8(sp)
    800027ca:	6a02                	ld	s4,0(sp)
    800027cc:	6145                	addi	sp,sp,48
    800027ce:	8082                	ret
      addr = balloc(ip->dev);
    800027d0:	0009a503          	lw	a0,0(s3)
    800027d4:	00000097          	auipc	ra,0x0
    800027d8:	e10080e7          	jalr	-496(ra) # 800025e4 <balloc>
    800027dc:	0005091b          	sext.w	s2,a0
      if(addr){
    800027e0:	fc090ae3          	beqz	s2,800027b4 <bmap+0x98>
        a[bn] = addr;
    800027e4:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800027e8:	8552                	mv	a0,s4
    800027ea:	00001097          	auipc	ra,0x1
    800027ee:	eec080e7          	jalr	-276(ra) # 800036d6 <log_write>
    800027f2:	b7c9                	j	800027b4 <bmap+0x98>
  panic("bmap: out of range");
    800027f4:	00006517          	auipc	a0,0x6
    800027f8:	d3450513          	addi	a0,a0,-716 # 80008528 <syscalls+0x118>
    800027fc:	00003097          	auipc	ra,0x3
    80002800:	3f2080e7          	jalr	1010(ra) # 80005bee <panic>

0000000080002804 <iget>:
{
    80002804:	7179                	addi	sp,sp,-48
    80002806:	f406                	sd	ra,40(sp)
    80002808:	f022                	sd	s0,32(sp)
    8000280a:	ec26                	sd	s1,24(sp)
    8000280c:	e84a                	sd	s2,16(sp)
    8000280e:	e44e                	sd	s3,8(sp)
    80002810:	e052                	sd	s4,0(sp)
    80002812:	1800                	addi	s0,sp,48
    80002814:	89aa                	mv	s3,a0
    80002816:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002818:	00014517          	auipc	a0,0x14
    8000281c:	63050513          	addi	a0,a0,1584 # 80016e48 <itable>
    80002820:	00004097          	auipc	ra,0x4
    80002824:	90a080e7          	jalr	-1782(ra) # 8000612a <acquire>
  empty = 0;
    80002828:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000282a:	00014497          	auipc	s1,0x14
    8000282e:	63648493          	addi	s1,s1,1590 # 80016e60 <itable+0x18>
    80002832:	00016697          	auipc	a3,0x16
    80002836:	0be68693          	addi	a3,a3,190 # 800188f0 <log>
    8000283a:	a039                	j	80002848 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000283c:	02090b63          	beqz	s2,80002872 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002840:	08848493          	addi	s1,s1,136
    80002844:	02d48a63          	beq	s1,a3,80002878 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002848:	449c                	lw	a5,8(s1)
    8000284a:	fef059e3          	blez	a5,8000283c <iget+0x38>
    8000284e:	4098                	lw	a4,0(s1)
    80002850:	ff3716e3          	bne	a4,s3,8000283c <iget+0x38>
    80002854:	40d8                	lw	a4,4(s1)
    80002856:	ff4713e3          	bne	a4,s4,8000283c <iget+0x38>
      ip->ref++;
    8000285a:	2785                	addiw	a5,a5,1
    8000285c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000285e:	00014517          	auipc	a0,0x14
    80002862:	5ea50513          	addi	a0,a0,1514 # 80016e48 <itable>
    80002866:	00004097          	auipc	ra,0x4
    8000286a:	978080e7          	jalr	-1672(ra) # 800061de <release>
      return ip;
    8000286e:	8926                	mv	s2,s1
    80002870:	a03d                	j	8000289e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002872:	f7f9                	bnez	a5,80002840 <iget+0x3c>
    80002874:	8926                	mv	s2,s1
    80002876:	b7e9                	j	80002840 <iget+0x3c>
  if(empty == 0)
    80002878:	02090c63          	beqz	s2,800028b0 <iget+0xac>
  ip->dev = dev;
    8000287c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002880:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002884:	4785                	li	a5,1
    80002886:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000288a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000288e:	00014517          	auipc	a0,0x14
    80002892:	5ba50513          	addi	a0,a0,1466 # 80016e48 <itable>
    80002896:	00004097          	auipc	ra,0x4
    8000289a:	948080e7          	jalr	-1720(ra) # 800061de <release>
}
    8000289e:	854a                	mv	a0,s2
    800028a0:	70a2                	ld	ra,40(sp)
    800028a2:	7402                	ld	s0,32(sp)
    800028a4:	64e2                	ld	s1,24(sp)
    800028a6:	6942                	ld	s2,16(sp)
    800028a8:	69a2                	ld	s3,8(sp)
    800028aa:	6a02                	ld	s4,0(sp)
    800028ac:	6145                	addi	sp,sp,48
    800028ae:	8082                	ret
    panic("iget: no inodes");
    800028b0:	00006517          	auipc	a0,0x6
    800028b4:	c9050513          	addi	a0,a0,-880 # 80008540 <syscalls+0x130>
    800028b8:	00003097          	auipc	ra,0x3
    800028bc:	336080e7          	jalr	822(ra) # 80005bee <panic>

00000000800028c0 <fsinit>:
fsinit(int dev) {
    800028c0:	7179                	addi	sp,sp,-48
    800028c2:	f406                	sd	ra,40(sp)
    800028c4:	f022                	sd	s0,32(sp)
    800028c6:	ec26                	sd	s1,24(sp)
    800028c8:	e84a                	sd	s2,16(sp)
    800028ca:	e44e                	sd	s3,8(sp)
    800028cc:	1800                	addi	s0,sp,48
    800028ce:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028d0:	4585                	li	a1,1
    800028d2:	00000097          	auipc	ra,0x0
    800028d6:	a50080e7          	jalr	-1456(ra) # 80002322 <bread>
    800028da:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028dc:	00014997          	auipc	s3,0x14
    800028e0:	54c98993          	addi	s3,s3,1356 # 80016e28 <sb>
    800028e4:	02000613          	li	a2,32
    800028e8:	05850593          	addi	a1,a0,88
    800028ec:	854e                	mv	a0,s3
    800028ee:	ffffe097          	auipc	ra,0xffffe
    800028f2:	8e6080e7          	jalr	-1818(ra) # 800001d4 <memmove>
  brelse(bp);
    800028f6:	8526                	mv	a0,s1
    800028f8:	00000097          	auipc	ra,0x0
    800028fc:	b5a080e7          	jalr	-1190(ra) # 80002452 <brelse>
  if(sb.magic != FSMAGIC)
    80002900:	0009a703          	lw	a4,0(s3)
    80002904:	102037b7          	lui	a5,0x10203
    80002908:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000290c:	02f71263          	bne	a4,a5,80002930 <fsinit+0x70>
  initlog(dev, &sb);
    80002910:	00014597          	auipc	a1,0x14
    80002914:	51858593          	addi	a1,a1,1304 # 80016e28 <sb>
    80002918:	854a                	mv	a0,s2
    8000291a:	00001097          	auipc	ra,0x1
    8000291e:	b40080e7          	jalr	-1216(ra) # 8000345a <initlog>
}
    80002922:	70a2                	ld	ra,40(sp)
    80002924:	7402                	ld	s0,32(sp)
    80002926:	64e2                	ld	s1,24(sp)
    80002928:	6942                	ld	s2,16(sp)
    8000292a:	69a2                	ld	s3,8(sp)
    8000292c:	6145                	addi	sp,sp,48
    8000292e:	8082                	ret
    panic("invalid file system");
    80002930:	00006517          	auipc	a0,0x6
    80002934:	c2050513          	addi	a0,a0,-992 # 80008550 <syscalls+0x140>
    80002938:	00003097          	auipc	ra,0x3
    8000293c:	2b6080e7          	jalr	694(ra) # 80005bee <panic>

0000000080002940 <iinit>:
{
    80002940:	7179                	addi	sp,sp,-48
    80002942:	f406                	sd	ra,40(sp)
    80002944:	f022                	sd	s0,32(sp)
    80002946:	ec26                	sd	s1,24(sp)
    80002948:	e84a                	sd	s2,16(sp)
    8000294a:	e44e                	sd	s3,8(sp)
    8000294c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000294e:	00006597          	auipc	a1,0x6
    80002952:	c1a58593          	addi	a1,a1,-998 # 80008568 <syscalls+0x158>
    80002956:	00014517          	auipc	a0,0x14
    8000295a:	4f250513          	addi	a0,a0,1266 # 80016e48 <itable>
    8000295e:	00003097          	auipc	ra,0x3
    80002962:	73c080e7          	jalr	1852(ra) # 8000609a <initlock>
  for(i = 0; i < NINODE; i++) {
    80002966:	00014497          	auipc	s1,0x14
    8000296a:	50a48493          	addi	s1,s1,1290 # 80016e70 <itable+0x28>
    8000296e:	00016997          	auipc	s3,0x16
    80002972:	f9298993          	addi	s3,s3,-110 # 80018900 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002976:	00006917          	auipc	s2,0x6
    8000297a:	bfa90913          	addi	s2,s2,-1030 # 80008570 <syscalls+0x160>
    8000297e:	85ca                	mv	a1,s2
    80002980:	8526                	mv	a0,s1
    80002982:	00001097          	auipc	ra,0x1
    80002986:	e3a080e7          	jalr	-454(ra) # 800037bc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000298a:	08848493          	addi	s1,s1,136
    8000298e:	ff3498e3          	bne	s1,s3,8000297e <iinit+0x3e>
}
    80002992:	70a2                	ld	ra,40(sp)
    80002994:	7402                	ld	s0,32(sp)
    80002996:	64e2                	ld	s1,24(sp)
    80002998:	6942                	ld	s2,16(sp)
    8000299a:	69a2                	ld	s3,8(sp)
    8000299c:	6145                	addi	sp,sp,48
    8000299e:	8082                	ret

00000000800029a0 <ialloc>:
{
    800029a0:	715d                	addi	sp,sp,-80
    800029a2:	e486                	sd	ra,72(sp)
    800029a4:	e0a2                	sd	s0,64(sp)
    800029a6:	fc26                	sd	s1,56(sp)
    800029a8:	f84a                	sd	s2,48(sp)
    800029aa:	f44e                	sd	s3,40(sp)
    800029ac:	f052                	sd	s4,32(sp)
    800029ae:	ec56                	sd	s5,24(sp)
    800029b0:	e85a                	sd	s6,16(sp)
    800029b2:	e45e                	sd	s7,8(sp)
    800029b4:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800029b6:	00014717          	auipc	a4,0x14
    800029ba:	47e72703          	lw	a4,1150(a4) # 80016e34 <sb+0xc>
    800029be:	4785                	li	a5,1
    800029c0:	04e7fa63          	bgeu	a5,a4,80002a14 <ialloc+0x74>
    800029c4:	8aaa                	mv	s5,a0
    800029c6:	8bae                	mv	s7,a1
    800029c8:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029ca:	00014a17          	auipc	s4,0x14
    800029ce:	45ea0a13          	addi	s4,s4,1118 # 80016e28 <sb>
    800029d2:	00048b1b          	sext.w	s6,s1
    800029d6:	0044d793          	srli	a5,s1,0x4
    800029da:	018a2583          	lw	a1,24(s4)
    800029de:	9dbd                	addw	a1,a1,a5
    800029e0:	8556                	mv	a0,s5
    800029e2:	00000097          	auipc	ra,0x0
    800029e6:	940080e7          	jalr	-1728(ra) # 80002322 <bread>
    800029ea:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029ec:	05850993          	addi	s3,a0,88
    800029f0:	00f4f793          	andi	a5,s1,15
    800029f4:	079a                	slli	a5,a5,0x6
    800029f6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029f8:	00099783          	lh	a5,0(s3)
    800029fc:	c3a1                	beqz	a5,80002a3c <ialloc+0x9c>
    brelse(bp);
    800029fe:	00000097          	auipc	ra,0x0
    80002a02:	a54080e7          	jalr	-1452(ra) # 80002452 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a06:	0485                	addi	s1,s1,1
    80002a08:	00ca2703          	lw	a4,12(s4)
    80002a0c:	0004879b          	sext.w	a5,s1
    80002a10:	fce7e1e3          	bltu	a5,a4,800029d2 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002a14:	00006517          	auipc	a0,0x6
    80002a18:	b6450513          	addi	a0,a0,-1180 # 80008578 <syscalls+0x168>
    80002a1c:	00003097          	auipc	ra,0x3
    80002a20:	21c080e7          	jalr	540(ra) # 80005c38 <printf>
  return 0;
    80002a24:	4501                	li	a0,0
}
    80002a26:	60a6                	ld	ra,72(sp)
    80002a28:	6406                	ld	s0,64(sp)
    80002a2a:	74e2                	ld	s1,56(sp)
    80002a2c:	7942                	ld	s2,48(sp)
    80002a2e:	79a2                	ld	s3,40(sp)
    80002a30:	7a02                	ld	s4,32(sp)
    80002a32:	6ae2                	ld	s5,24(sp)
    80002a34:	6b42                	ld	s6,16(sp)
    80002a36:	6ba2                	ld	s7,8(sp)
    80002a38:	6161                	addi	sp,sp,80
    80002a3a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002a3c:	04000613          	li	a2,64
    80002a40:	4581                	li	a1,0
    80002a42:	854e                	mv	a0,s3
    80002a44:	ffffd097          	auipc	ra,0xffffd
    80002a48:	734080e7          	jalr	1844(ra) # 80000178 <memset>
      dip->type = type;
    80002a4c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a50:	854a                	mv	a0,s2
    80002a52:	00001097          	auipc	ra,0x1
    80002a56:	c84080e7          	jalr	-892(ra) # 800036d6 <log_write>
      brelse(bp);
    80002a5a:	854a                	mv	a0,s2
    80002a5c:	00000097          	auipc	ra,0x0
    80002a60:	9f6080e7          	jalr	-1546(ra) # 80002452 <brelse>
      return iget(dev, inum);
    80002a64:	85da                	mv	a1,s6
    80002a66:	8556                	mv	a0,s5
    80002a68:	00000097          	auipc	ra,0x0
    80002a6c:	d9c080e7          	jalr	-612(ra) # 80002804 <iget>
    80002a70:	bf5d                	j	80002a26 <ialloc+0x86>

0000000080002a72 <iupdate>:
{
    80002a72:	1101                	addi	sp,sp,-32
    80002a74:	ec06                	sd	ra,24(sp)
    80002a76:	e822                	sd	s0,16(sp)
    80002a78:	e426                	sd	s1,8(sp)
    80002a7a:	e04a                	sd	s2,0(sp)
    80002a7c:	1000                	addi	s0,sp,32
    80002a7e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a80:	415c                	lw	a5,4(a0)
    80002a82:	0047d79b          	srliw	a5,a5,0x4
    80002a86:	00014597          	auipc	a1,0x14
    80002a8a:	3ba5a583          	lw	a1,954(a1) # 80016e40 <sb+0x18>
    80002a8e:	9dbd                	addw	a1,a1,a5
    80002a90:	4108                	lw	a0,0(a0)
    80002a92:	00000097          	auipc	ra,0x0
    80002a96:	890080e7          	jalr	-1904(ra) # 80002322 <bread>
    80002a9a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a9c:	05850793          	addi	a5,a0,88
    80002aa0:	40c8                	lw	a0,4(s1)
    80002aa2:	893d                	andi	a0,a0,15
    80002aa4:	051a                	slli	a0,a0,0x6
    80002aa6:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002aa8:	04449703          	lh	a4,68(s1)
    80002aac:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002ab0:	04649703          	lh	a4,70(s1)
    80002ab4:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002ab8:	04849703          	lh	a4,72(s1)
    80002abc:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002ac0:	04a49703          	lh	a4,74(s1)
    80002ac4:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ac8:	44f8                	lw	a4,76(s1)
    80002aca:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002acc:	03400613          	li	a2,52
    80002ad0:	05048593          	addi	a1,s1,80
    80002ad4:	0531                	addi	a0,a0,12
    80002ad6:	ffffd097          	auipc	ra,0xffffd
    80002ada:	6fe080e7          	jalr	1790(ra) # 800001d4 <memmove>
  log_write(bp);
    80002ade:	854a                	mv	a0,s2
    80002ae0:	00001097          	auipc	ra,0x1
    80002ae4:	bf6080e7          	jalr	-1034(ra) # 800036d6 <log_write>
  brelse(bp);
    80002ae8:	854a                	mv	a0,s2
    80002aea:	00000097          	auipc	ra,0x0
    80002aee:	968080e7          	jalr	-1688(ra) # 80002452 <brelse>
}
    80002af2:	60e2                	ld	ra,24(sp)
    80002af4:	6442                	ld	s0,16(sp)
    80002af6:	64a2                	ld	s1,8(sp)
    80002af8:	6902                	ld	s2,0(sp)
    80002afa:	6105                	addi	sp,sp,32
    80002afc:	8082                	ret

0000000080002afe <idup>:
{
    80002afe:	1101                	addi	sp,sp,-32
    80002b00:	ec06                	sd	ra,24(sp)
    80002b02:	e822                	sd	s0,16(sp)
    80002b04:	e426                	sd	s1,8(sp)
    80002b06:	1000                	addi	s0,sp,32
    80002b08:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b0a:	00014517          	auipc	a0,0x14
    80002b0e:	33e50513          	addi	a0,a0,830 # 80016e48 <itable>
    80002b12:	00003097          	auipc	ra,0x3
    80002b16:	618080e7          	jalr	1560(ra) # 8000612a <acquire>
  ip->ref++;
    80002b1a:	449c                	lw	a5,8(s1)
    80002b1c:	2785                	addiw	a5,a5,1
    80002b1e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b20:	00014517          	auipc	a0,0x14
    80002b24:	32850513          	addi	a0,a0,808 # 80016e48 <itable>
    80002b28:	00003097          	auipc	ra,0x3
    80002b2c:	6b6080e7          	jalr	1718(ra) # 800061de <release>
}
    80002b30:	8526                	mv	a0,s1
    80002b32:	60e2                	ld	ra,24(sp)
    80002b34:	6442                	ld	s0,16(sp)
    80002b36:	64a2                	ld	s1,8(sp)
    80002b38:	6105                	addi	sp,sp,32
    80002b3a:	8082                	ret

0000000080002b3c <ilock>:
{
    80002b3c:	1101                	addi	sp,sp,-32
    80002b3e:	ec06                	sd	ra,24(sp)
    80002b40:	e822                	sd	s0,16(sp)
    80002b42:	e426                	sd	s1,8(sp)
    80002b44:	e04a                	sd	s2,0(sp)
    80002b46:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b48:	c115                	beqz	a0,80002b6c <ilock+0x30>
    80002b4a:	84aa                	mv	s1,a0
    80002b4c:	451c                	lw	a5,8(a0)
    80002b4e:	00f05f63          	blez	a5,80002b6c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b52:	0541                	addi	a0,a0,16
    80002b54:	00001097          	auipc	ra,0x1
    80002b58:	ca2080e7          	jalr	-862(ra) # 800037f6 <acquiresleep>
  if(ip->valid == 0){
    80002b5c:	40bc                	lw	a5,64(s1)
    80002b5e:	cf99                	beqz	a5,80002b7c <ilock+0x40>
}
    80002b60:	60e2                	ld	ra,24(sp)
    80002b62:	6442                	ld	s0,16(sp)
    80002b64:	64a2                	ld	s1,8(sp)
    80002b66:	6902                	ld	s2,0(sp)
    80002b68:	6105                	addi	sp,sp,32
    80002b6a:	8082                	ret
    panic("ilock");
    80002b6c:	00006517          	auipc	a0,0x6
    80002b70:	a2450513          	addi	a0,a0,-1500 # 80008590 <syscalls+0x180>
    80002b74:	00003097          	auipc	ra,0x3
    80002b78:	07a080e7          	jalr	122(ra) # 80005bee <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b7c:	40dc                	lw	a5,4(s1)
    80002b7e:	0047d79b          	srliw	a5,a5,0x4
    80002b82:	00014597          	auipc	a1,0x14
    80002b86:	2be5a583          	lw	a1,702(a1) # 80016e40 <sb+0x18>
    80002b8a:	9dbd                	addw	a1,a1,a5
    80002b8c:	4088                	lw	a0,0(s1)
    80002b8e:	fffff097          	auipc	ra,0xfffff
    80002b92:	794080e7          	jalr	1940(ra) # 80002322 <bread>
    80002b96:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b98:	05850593          	addi	a1,a0,88
    80002b9c:	40dc                	lw	a5,4(s1)
    80002b9e:	8bbd                	andi	a5,a5,15
    80002ba0:	079a                	slli	a5,a5,0x6
    80002ba2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ba4:	00059783          	lh	a5,0(a1)
    80002ba8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002bac:	00259783          	lh	a5,2(a1)
    80002bb0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bb4:	00459783          	lh	a5,4(a1)
    80002bb8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bbc:	00659783          	lh	a5,6(a1)
    80002bc0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bc4:	459c                	lw	a5,8(a1)
    80002bc6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bc8:	03400613          	li	a2,52
    80002bcc:	05b1                	addi	a1,a1,12
    80002bce:	05048513          	addi	a0,s1,80
    80002bd2:	ffffd097          	auipc	ra,0xffffd
    80002bd6:	602080e7          	jalr	1538(ra) # 800001d4 <memmove>
    brelse(bp);
    80002bda:	854a                	mv	a0,s2
    80002bdc:	00000097          	auipc	ra,0x0
    80002be0:	876080e7          	jalr	-1930(ra) # 80002452 <brelse>
    ip->valid = 1;
    80002be4:	4785                	li	a5,1
    80002be6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002be8:	04449783          	lh	a5,68(s1)
    80002bec:	fbb5                	bnez	a5,80002b60 <ilock+0x24>
      panic("ilock: no type");
    80002bee:	00006517          	auipc	a0,0x6
    80002bf2:	9aa50513          	addi	a0,a0,-1622 # 80008598 <syscalls+0x188>
    80002bf6:	00003097          	auipc	ra,0x3
    80002bfa:	ff8080e7          	jalr	-8(ra) # 80005bee <panic>

0000000080002bfe <iunlock>:
{
    80002bfe:	1101                	addi	sp,sp,-32
    80002c00:	ec06                	sd	ra,24(sp)
    80002c02:	e822                	sd	s0,16(sp)
    80002c04:	e426                	sd	s1,8(sp)
    80002c06:	e04a                	sd	s2,0(sp)
    80002c08:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c0a:	c905                	beqz	a0,80002c3a <iunlock+0x3c>
    80002c0c:	84aa                	mv	s1,a0
    80002c0e:	01050913          	addi	s2,a0,16
    80002c12:	854a                	mv	a0,s2
    80002c14:	00001097          	auipc	ra,0x1
    80002c18:	c7c080e7          	jalr	-900(ra) # 80003890 <holdingsleep>
    80002c1c:	cd19                	beqz	a0,80002c3a <iunlock+0x3c>
    80002c1e:	449c                	lw	a5,8(s1)
    80002c20:	00f05d63          	blez	a5,80002c3a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c24:	854a                	mv	a0,s2
    80002c26:	00001097          	auipc	ra,0x1
    80002c2a:	c26080e7          	jalr	-986(ra) # 8000384c <releasesleep>
}
    80002c2e:	60e2                	ld	ra,24(sp)
    80002c30:	6442                	ld	s0,16(sp)
    80002c32:	64a2                	ld	s1,8(sp)
    80002c34:	6902                	ld	s2,0(sp)
    80002c36:	6105                	addi	sp,sp,32
    80002c38:	8082                	ret
    panic("iunlock");
    80002c3a:	00006517          	auipc	a0,0x6
    80002c3e:	96e50513          	addi	a0,a0,-1682 # 800085a8 <syscalls+0x198>
    80002c42:	00003097          	auipc	ra,0x3
    80002c46:	fac080e7          	jalr	-84(ra) # 80005bee <panic>

0000000080002c4a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c4a:	7179                	addi	sp,sp,-48
    80002c4c:	f406                	sd	ra,40(sp)
    80002c4e:	f022                	sd	s0,32(sp)
    80002c50:	ec26                	sd	s1,24(sp)
    80002c52:	e84a                	sd	s2,16(sp)
    80002c54:	e44e                	sd	s3,8(sp)
    80002c56:	e052                	sd	s4,0(sp)
    80002c58:	1800                	addi	s0,sp,48
    80002c5a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c5c:	05050493          	addi	s1,a0,80
    80002c60:	08050913          	addi	s2,a0,128
    80002c64:	a021                	j	80002c6c <itrunc+0x22>
    80002c66:	0491                	addi	s1,s1,4
    80002c68:	01248d63          	beq	s1,s2,80002c82 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c6c:	408c                	lw	a1,0(s1)
    80002c6e:	dde5                	beqz	a1,80002c66 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c70:	0009a503          	lw	a0,0(s3)
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	8f4080e7          	jalr	-1804(ra) # 80002568 <bfree>
      ip->addrs[i] = 0;
    80002c7c:	0004a023          	sw	zero,0(s1)
    80002c80:	b7dd                	j	80002c66 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c82:	0809a583          	lw	a1,128(s3)
    80002c86:	e185                	bnez	a1,80002ca6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c88:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c8c:	854e                	mv	a0,s3
    80002c8e:	00000097          	auipc	ra,0x0
    80002c92:	de4080e7          	jalr	-540(ra) # 80002a72 <iupdate>
}
    80002c96:	70a2                	ld	ra,40(sp)
    80002c98:	7402                	ld	s0,32(sp)
    80002c9a:	64e2                	ld	s1,24(sp)
    80002c9c:	6942                	ld	s2,16(sp)
    80002c9e:	69a2                	ld	s3,8(sp)
    80002ca0:	6a02                	ld	s4,0(sp)
    80002ca2:	6145                	addi	sp,sp,48
    80002ca4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ca6:	0009a503          	lw	a0,0(s3)
    80002caa:	fffff097          	auipc	ra,0xfffff
    80002cae:	678080e7          	jalr	1656(ra) # 80002322 <bread>
    80002cb2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cb4:	05850493          	addi	s1,a0,88
    80002cb8:	45850913          	addi	s2,a0,1112
    80002cbc:	a021                	j	80002cc4 <itrunc+0x7a>
    80002cbe:	0491                	addi	s1,s1,4
    80002cc0:	01248b63          	beq	s1,s2,80002cd6 <itrunc+0x8c>
      if(a[j])
    80002cc4:	408c                	lw	a1,0(s1)
    80002cc6:	dde5                	beqz	a1,80002cbe <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002cc8:	0009a503          	lw	a0,0(s3)
    80002ccc:	00000097          	auipc	ra,0x0
    80002cd0:	89c080e7          	jalr	-1892(ra) # 80002568 <bfree>
    80002cd4:	b7ed                	j	80002cbe <itrunc+0x74>
    brelse(bp);
    80002cd6:	8552                	mv	a0,s4
    80002cd8:	fffff097          	auipc	ra,0xfffff
    80002cdc:	77a080e7          	jalr	1914(ra) # 80002452 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ce0:	0809a583          	lw	a1,128(s3)
    80002ce4:	0009a503          	lw	a0,0(s3)
    80002ce8:	00000097          	auipc	ra,0x0
    80002cec:	880080e7          	jalr	-1920(ra) # 80002568 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cf0:	0809a023          	sw	zero,128(s3)
    80002cf4:	bf51                	j	80002c88 <itrunc+0x3e>

0000000080002cf6 <iput>:
{
    80002cf6:	1101                	addi	sp,sp,-32
    80002cf8:	ec06                	sd	ra,24(sp)
    80002cfa:	e822                	sd	s0,16(sp)
    80002cfc:	e426                	sd	s1,8(sp)
    80002cfe:	e04a                	sd	s2,0(sp)
    80002d00:	1000                	addi	s0,sp,32
    80002d02:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d04:	00014517          	auipc	a0,0x14
    80002d08:	14450513          	addi	a0,a0,324 # 80016e48 <itable>
    80002d0c:	00003097          	auipc	ra,0x3
    80002d10:	41e080e7          	jalr	1054(ra) # 8000612a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d14:	4498                	lw	a4,8(s1)
    80002d16:	4785                	li	a5,1
    80002d18:	02f70363          	beq	a4,a5,80002d3e <iput+0x48>
  ip->ref--;
    80002d1c:	449c                	lw	a5,8(s1)
    80002d1e:	37fd                	addiw	a5,a5,-1
    80002d20:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d22:	00014517          	auipc	a0,0x14
    80002d26:	12650513          	addi	a0,a0,294 # 80016e48 <itable>
    80002d2a:	00003097          	auipc	ra,0x3
    80002d2e:	4b4080e7          	jalr	1204(ra) # 800061de <release>
}
    80002d32:	60e2                	ld	ra,24(sp)
    80002d34:	6442                	ld	s0,16(sp)
    80002d36:	64a2                	ld	s1,8(sp)
    80002d38:	6902                	ld	s2,0(sp)
    80002d3a:	6105                	addi	sp,sp,32
    80002d3c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d3e:	40bc                	lw	a5,64(s1)
    80002d40:	dff1                	beqz	a5,80002d1c <iput+0x26>
    80002d42:	04a49783          	lh	a5,74(s1)
    80002d46:	fbf9                	bnez	a5,80002d1c <iput+0x26>
    acquiresleep(&ip->lock);
    80002d48:	01048913          	addi	s2,s1,16
    80002d4c:	854a                	mv	a0,s2
    80002d4e:	00001097          	auipc	ra,0x1
    80002d52:	aa8080e7          	jalr	-1368(ra) # 800037f6 <acquiresleep>
    release(&itable.lock);
    80002d56:	00014517          	auipc	a0,0x14
    80002d5a:	0f250513          	addi	a0,a0,242 # 80016e48 <itable>
    80002d5e:	00003097          	auipc	ra,0x3
    80002d62:	480080e7          	jalr	1152(ra) # 800061de <release>
    itrunc(ip);
    80002d66:	8526                	mv	a0,s1
    80002d68:	00000097          	auipc	ra,0x0
    80002d6c:	ee2080e7          	jalr	-286(ra) # 80002c4a <itrunc>
    ip->type = 0;
    80002d70:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d74:	8526                	mv	a0,s1
    80002d76:	00000097          	auipc	ra,0x0
    80002d7a:	cfc080e7          	jalr	-772(ra) # 80002a72 <iupdate>
    ip->valid = 0;
    80002d7e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d82:	854a                	mv	a0,s2
    80002d84:	00001097          	auipc	ra,0x1
    80002d88:	ac8080e7          	jalr	-1336(ra) # 8000384c <releasesleep>
    acquire(&itable.lock);
    80002d8c:	00014517          	auipc	a0,0x14
    80002d90:	0bc50513          	addi	a0,a0,188 # 80016e48 <itable>
    80002d94:	00003097          	auipc	ra,0x3
    80002d98:	396080e7          	jalr	918(ra) # 8000612a <acquire>
    80002d9c:	b741                	j	80002d1c <iput+0x26>

0000000080002d9e <iunlockput>:
{
    80002d9e:	1101                	addi	sp,sp,-32
    80002da0:	ec06                	sd	ra,24(sp)
    80002da2:	e822                	sd	s0,16(sp)
    80002da4:	e426                	sd	s1,8(sp)
    80002da6:	1000                	addi	s0,sp,32
    80002da8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002daa:	00000097          	auipc	ra,0x0
    80002dae:	e54080e7          	jalr	-428(ra) # 80002bfe <iunlock>
  iput(ip);
    80002db2:	8526                	mv	a0,s1
    80002db4:	00000097          	auipc	ra,0x0
    80002db8:	f42080e7          	jalr	-190(ra) # 80002cf6 <iput>
}
    80002dbc:	60e2                	ld	ra,24(sp)
    80002dbe:	6442                	ld	s0,16(sp)
    80002dc0:	64a2                	ld	s1,8(sp)
    80002dc2:	6105                	addi	sp,sp,32
    80002dc4:	8082                	ret

0000000080002dc6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002dc6:	1141                	addi	sp,sp,-16
    80002dc8:	e422                	sd	s0,8(sp)
    80002dca:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002dcc:	411c                	lw	a5,0(a0)
    80002dce:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002dd0:	415c                	lw	a5,4(a0)
    80002dd2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dd4:	04451783          	lh	a5,68(a0)
    80002dd8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ddc:	04a51783          	lh	a5,74(a0)
    80002de0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002de4:	04c56783          	lwu	a5,76(a0)
    80002de8:	e99c                	sd	a5,16(a1)
}
    80002dea:	6422                	ld	s0,8(sp)
    80002dec:	0141                	addi	sp,sp,16
    80002dee:	8082                	ret

0000000080002df0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002df0:	457c                	lw	a5,76(a0)
    80002df2:	0ed7e963          	bltu	a5,a3,80002ee4 <readi+0xf4>
{
    80002df6:	7159                	addi	sp,sp,-112
    80002df8:	f486                	sd	ra,104(sp)
    80002dfa:	f0a2                	sd	s0,96(sp)
    80002dfc:	eca6                	sd	s1,88(sp)
    80002dfe:	e8ca                	sd	s2,80(sp)
    80002e00:	e4ce                	sd	s3,72(sp)
    80002e02:	e0d2                	sd	s4,64(sp)
    80002e04:	fc56                	sd	s5,56(sp)
    80002e06:	f85a                	sd	s6,48(sp)
    80002e08:	f45e                	sd	s7,40(sp)
    80002e0a:	f062                	sd	s8,32(sp)
    80002e0c:	ec66                	sd	s9,24(sp)
    80002e0e:	e86a                	sd	s10,16(sp)
    80002e10:	e46e                	sd	s11,8(sp)
    80002e12:	1880                	addi	s0,sp,112
    80002e14:	8b2a                	mv	s6,a0
    80002e16:	8bae                	mv	s7,a1
    80002e18:	8a32                	mv	s4,a2
    80002e1a:	84b6                	mv	s1,a3
    80002e1c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e1e:	9f35                	addw	a4,a4,a3
    return 0;
    80002e20:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e22:	0ad76063          	bltu	a4,a3,80002ec2 <readi+0xd2>
  if(off + n > ip->size)
    80002e26:	00e7f463          	bgeu	a5,a4,80002e2e <readi+0x3e>
    n = ip->size - off;
    80002e2a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e2e:	0a0a8963          	beqz	s5,80002ee0 <readi+0xf0>
    80002e32:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e34:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e38:	5c7d                	li	s8,-1
    80002e3a:	a82d                	j	80002e74 <readi+0x84>
    80002e3c:	020d1d93          	slli	s11,s10,0x20
    80002e40:	020ddd93          	srli	s11,s11,0x20
    80002e44:	05890793          	addi	a5,s2,88
    80002e48:	86ee                	mv	a3,s11
    80002e4a:	963e                	add	a2,a2,a5
    80002e4c:	85d2                	mv	a1,s4
    80002e4e:	855e                	mv	a0,s7
    80002e50:	fffff097          	auipc	ra,0xfffff
    80002e54:	b0e080e7          	jalr	-1266(ra) # 8000195e <either_copyout>
    80002e58:	05850d63          	beq	a0,s8,80002eb2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e5c:	854a                	mv	a0,s2
    80002e5e:	fffff097          	auipc	ra,0xfffff
    80002e62:	5f4080e7          	jalr	1524(ra) # 80002452 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e66:	013d09bb          	addw	s3,s10,s3
    80002e6a:	009d04bb          	addw	s1,s10,s1
    80002e6e:	9a6e                	add	s4,s4,s11
    80002e70:	0559f763          	bgeu	s3,s5,80002ebe <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e74:	00a4d59b          	srliw	a1,s1,0xa
    80002e78:	855a                	mv	a0,s6
    80002e7a:	00000097          	auipc	ra,0x0
    80002e7e:	8a2080e7          	jalr	-1886(ra) # 8000271c <bmap>
    80002e82:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e86:	cd85                	beqz	a1,80002ebe <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e88:	000b2503          	lw	a0,0(s6)
    80002e8c:	fffff097          	auipc	ra,0xfffff
    80002e90:	496080e7          	jalr	1174(ra) # 80002322 <bread>
    80002e94:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e96:	3ff4f613          	andi	a2,s1,1023
    80002e9a:	40cc87bb          	subw	a5,s9,a2
    80002e9e:	413a873b          	subw	a4,s5,s3
    80002ea2:	8d3e                	mv	s10,a5
    80002ea4:	2781                	sext.w	a5,a5
    80002ea6:	0007069b          	sext.w	a3,a4
    80002eaa:	f8f6f9e3          	bgeu	a3,a5,80002e3c <readi+0x4c>
    80002eae:	8d3a                	mv	s10,a4
    80002eb0:	b771                	j	80002e3c <readi+0x4c>
      brelse(bp);
    80002eb2:	854a                	mv	a0,s2
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	59e080e7          	jalr	1438(ra) # 80002452 <brelse>
      tot = -1;
    80002ebc:	59fd                	li	s3,-1
  }
  return tot;
    80002ebe:	0009851b          	sext.w	a0,s3
}
    80002ec2:	70a6                	ld	ra,104(sp)
    80002ec4:	7406                	ld	s0,96(sp)
    80002ec6:	64e6                	ld	s1,88(sp)
    80002ec8:	6946                	ld	s2,80(sp)
    80002eca:	69a6                	ld	s3,72(sp)
    80002ecc:	6a06                	ld	s4,64(sp)
    80002ece:	7ae2                	ld	s5,56(sp)
    80002ed0:	7b42                	ld	s6,48(sp)
    80002ed2:	7ba2                	ld	s7,40(sp)
    80002ed4:	7c02                	ld	s8,32(sp)
    80002ed6:	6ce2                	ld	s9,24(sp)
    80002ed8:	6d42                	ld	s10,16(sp)
    80002eda:	6da2                	ld	s11,8(sp)
    80002edc:	6165                	addi	sp,sp,112
    80002ede:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ee0:	89d6                	mv	s3,s5
    80002ee2:	bff1                	j	80002ebe <readi+0xce>
    return 0;
    80002ee4:	4501                	li	a0,0
}
    80002ee6:	8082                	ret

0000000080002ee8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ee8:	457c                	lw	a5,76(a0)
    80002eea:	10d7e863          	bltu	a5,a3,80002ffa <writei+0x112>
{
    80002eee:	7159                	addi	sp,sp,-112
    80002ef0:	f486                	sd	ra,104(sp)
    80002ef2:	f0a2                	sd	s0,96(sp)
    80002ef4:	eca6                	sd	s1,88(sp)
    80002ef6:	e8ca                	sd	s2,80(sp)
    80002ef8:	e4ce                	sd	s3,72(sp)
    80002efa:	e0d2                	sd	s4,64(sp)
    80002efc:	fc56                	sd	s5,56(sp)
    80002efe:	f85a                	sd	s6,48(sp)
    80002f00:	f45e                	sd	s7,40(sp)
    80002f02:	f062                	sd	s8,32(sp)
    80002f04:	ec66                	sd	s9,24(sp)
    80002f06:	e86a                	sd	s10,16(sp)
    80002f08:	e46e                	sd	s11,8(sp)
    80002f0a:	1880                	addi	s0,sp,112
    80002f0c:	8aaa                	mv	s5,a0
    80002f0e:	8bae                	mv	s7,a1
    80002f10:	8a32                	mv	s4,a2
    80002f12:	8936                	mv	s2,a3
    80002f14:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f16:	00e687bb          	addw	a5,a3,a4
    80002f1a:	0ed7e263          	bltu	a5,a3,80002ffe <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f1e:	00043737          	lui	a4,0x43
    80002f22:	0ef76063          	bltu	a4,a5,80003002 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f26:	0c0b0863          	beqz	s6,80002ff6 <writei+0x10e>
    80002f2a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f2c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f30:	5c7d                	li	s8,-1
    80002f32:	a091                	j	80002f76 <writei+0x8e>
    80002f34:	020d1d93          	slli	s11,s10,0x20
    80002f38:	020ddd93          	srli	s11,s11,0x20
    80002f3c:	05848793          	addi	a5,s1,88
    80002f40:	86ee                	mv	a3,s11
    80002f42:	8652                	mv	a2,s4
    80002f44:	85de                	mv	a1,s7
    80002f46:	953e                	add	a0,a0,a5
    80002f48:	fffff097          	auipc	ra,0xfffff
    80002f4c:	a6c080e7          	jalr	-1428(ra) # 800019b4 <either_copyin>
    80002f50:	07850263          	beq	a0,s8,80002fb4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f54:	8526                	mv	a0,s1
    80002f56:	00000097          	auipc	ra,0x0
    80002f5a:	780080e7          	jalr	1920(ra) # 800036d6 <log_write>
    brelse(bp);
    80002f5e:	8526                	mv	a0,s1
    80002f60:	fffff097          	auipc	ra,0xfffff
    80002f64:	4f2080e7          	jalr	1266(ra) # 80002452 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f68:	013d09bb          	addw	s3,s10,s3
    80002f6c:	012d093b          	addw	s2,s10,s2
    80002f70:	9a6e                	add	s4,s4,s11
    80002f72:	0569f663          	bgeu	s3,s6,80002fbe <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f76:	00a9559b          	srliw	a1,s2,0xa
    80002f7a:	8556                	mv	a0,s5
    80002f7c:	fffff097          	auipc	ra,0xfffff
    80002f80:	7a0080e7          	jalr	1952(ra) # 8000271c <bmap>
    80002f84:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f88:	c99d                	beqz	a1,80002fbe <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f8a:	000aa503          	lw	a0,0(s5)
    80002f8e:	fffff097          	auipc	ra,0xfffff
    80002f92:	394080e7          	jalr	916(ra) # 80002322 <bread>
    80002f96:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f98:	3ff97513          	andi	a0,s2,1023
    80002f9c:	40ac87bb          	subw	a5,s9,a0
    80002fa0:	413b073b          	subw	a4,s6,s3
    80002fa4:	8d3e                	mv	s10,a5
    80002fa6:	2781                	sext.w	a5,a5
    80002fa8:	0007069b          	sext.w	a3,a4
    80002fac:	f8f6f4e3          	bgeu	a3,a5,80002f34 <writei+0x4c>
    80002fb0:	8d3a                	mv	s10,a4
    80002fb2:	b749                	j	80002f34 <writei+0x4c>
      brelse(bp);
    80002fb4:	8526                	mv	a0,s1
    80002fb6:	fffff097          	auipc	ra,0xfffff
    80002fba:	49c080e7          	jalr	1180(ra) # 80002452 <brelse>
  }

  if(off > ip->size)
    80002fbe:	04caa783          	lw	a5,76(s5)
    80002fc2:	0127f463          	bgeu	a5,s2,80002fca <writei+0xe2>
    ip->size = off;
    80002fc6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fca:	8556                	mv	a0,s5
    80002fcc:	00000097          	auipc	ra,0x0
    80002fd0:	aa6080e7          	jalr	-1370(ra) # 80002a72 <iupdate>

  return tot;
    80002fd4:	0009851b          	sext.w	a0,s3
}
    80002fd8:	70a6                	ld	ra,104(sp)
    80002fda:	7406                	ld	s0,96(sp)
    80002fdc:	64e6                	ld	s1,88(sp)
    80002fde:	6946                	ld	s2,80(sp)
    80002fe0:	69a6                	ld	s3,72(sp)
    80002fe2:	6a06                	ld	s4,64(sp)
    80002fe4:	7ae2                	ld	s5,56(sp)
    80002fe6:	7b42                	ld	s6,48(sp)
    80002fe8:	7ba2                	ld	s7,40(sp)
    80002fea:	7c02                	ld	s8,32(sp)
    80002fec:	6ce2                	ld	s9,24(sp)
    80002fee:	6d42                	ld	s10,16(sp)
    80002ff0:	6da2                	ld	s11,8(sp)
    80002ff2:	6165                	addi	sp,sp,112
    80002ff4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ff6:	89da                	mv	s3,s6
    80002ff8:	bfc9                	j	80002fca <writei+0xe2>
    return -1;
    80002ffa:	557d                	li	a0,-1
}
    80002ffc:	8082                	ret
    return -1;
    80002ffe:	557d                	li	a0,-1
    80003000:	bfe1                	j	80002fd8 <writei+0xf0>
    return -1;
    80003002:	557d                	li	a0,-1
    80003004:	bfd1                	j	80002fd8 <writei+0xf0>

0000000080003006 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003006:	1141                	addi	sp,sp,-16
    80003008:	e406                	sd	ra,8(sp)
    8000300a:	e022                	sd	s0,0(sp)
    8000300c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000300e:	4639                	li	a2,14
    80003010:	ffffd097          	auipc	ra,0xffffd
    80003014:	238080e7          	jalr	568(ra) # 80000248 <strncmp>
}
    80003018:	60a2                	ld	ra,8(sp)
    8000301a:	6402                	ld	s0,0(sp)
    8000301c:	0141                	addi	sp,sp,16
    8000301e:	8082                	ret

0000000080003020 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003020:	7139                	addi	sp,sp,-64
    80003022:	fc06                	sd	ra,56(sp)
    80003024:	f822                	sd	s0,48(sp)
    80003026:	f426                	sd	s1,40(sp)
    80003028:	f04a                	sd	s2,32(sp)
    8000302a:	ec4e                	sd	s3,24(sp)
    8000302c:	e852                	sd	s4,16(sp)
    8000302e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003030:	04451703          	lh	a4,68(a0)
    80003034:	4785                	li	a5,1
    80003036:	00f71a63          	bne	a4,a5,8000304a <dirlookup+0x2a>
    8000303a:	892a                	mv	s2,a0
    8000303c:	89ae                	mv	s3,a1
    8000303e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003040:	457c                	lw	a5,76(a0)
    80003042:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003044:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003046:	e79d                	bnez	a5,80003074 <dirlookup+0x54>
    80003048:	a8a5                	j	800030c0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000304a:	00005517          	auipc	a0,0x5
    8000304e:	56650513          	addi	a0,a0,1382 # 800085b0 <syscalls+0x1a0>
    80003052:	00003097          	auipc	ra,0x3
    80003056:	b9c080e7          	jalr	-1124(ra) # 80005bee <panic>
      panic("dirlookup read");
    8000305a:	00005517          	auipc	a0,0x5
    8000305e:	56e50513          	addi	a0,a0,1390 # 800085c8 <syscalls+0x1b8>
    80003062:	00003097          	auipc	ra,0x3
    80003066:	b8c080e7          	jalr	-1140(ra) # 80005bee <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000306a:	24c1                	addiw	s1,s1,16
    8000306c:	04c92783          	lw	a5,76(s2)
    80003070:	04f4f763          	bgeu	s1,a5,800030be <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003074:	4741                	li	a4,16
    80003076:	86a6                	mv	a3,s1
    80003078:	fc040613          	addi	a2,s0,-64
    8000307c:	4581                	li	a1,0
    8000307e:	854a                	mv	a0,s2
    80003080:	00000097          	auipc	ra,0x0
    80003084:	d70080e7          	jalr	-656(ra) # 80002df0 <readi>
    80003088:	47c1                	li	a5,16
    8000308a:	fcf518e3          	bne	a0,a5,8000305a <dirlookup+0x3a>
    if(de.inum == 0)
    8000308e:	fc045783          	lhu	a5,-64(s0)
    80003092:	dfe1                	beqz	a5,8000306a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003094:	fc240593          	addi	a1,s0,-62
    80003098:	854e                	mv	a0,s3
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	f6c080e7          	jalr	-148(ra) # 80003006 <namecmp>
    800030a2:	f561                	bnez	a0,8000306a <dirlookup+0x4a>
      if(poff)
    800030a4:	000a0463          	beqz	s4,800030ac <dirlookup+0x8c>
        *poff = off;
    800030a8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030ac:	fc045583          	lhu	a1,-64(s0)
    800030b0:	00092503          	lw	a0,0(s2)
    800030b4:	fffff097          	auipc	ra,0xfffff
    800030b8:	750080e7          	jalr	1872(ra) # 80002804 <iget>
    800030bc:	a011                	j	800030c0 <dirlookup+0xa0>
  return 0;
    800030be:	4501                	li	a0,0
}
    800030c0:	70e2                	ld	ra,56(sp)
    800030c2:	7442                	ld	s0,48(sp)
    800030c4:	74a2                	ld	s1,40(sp)
    800030c6:	7902                	ld	s2,32(sp)
    800030c8:	69e2                	ld	s3,24(sp)
    800030ca:	6a42                	ld	s4,16(sp)
    800030cc:	6121                	addi	sp,sp,64
    800030ce:	8082                	ret

00000000800030d0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030d0:	711d                	addi	sp,sp,-96
    800030d2:	ec86                	sd	ra,88(sp)
    800030d4:	e8a2                	sd	s0,80(sp)
    800030d6:	e4a6                	sd	s1,72(sp)
    800030d8:	e0ca                	sd	s2,64(sp)
    800030da:	fc4e                	sd	s3,56(sp)
    800030dc:	f852                	sd	s4,48(sp)
    800030de:	f456                	sd	s5,40(sp)
    800030e0:	f05a                	sd	s6,32(sp)
    800030e2:	ec5e                	sd	s7,24(sp)
    800030e4:	e862                	sd	s8,16(sp)
    800030e6:	e466                	sd	s9,8(sp)
    800030e8:	1080                	addi	s0,sp,96
    800030ea:	84aa                	mv	s1,a0
    800030ec:	8aae                	mv	s5,a1
    800030ee:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030f0:	00054703          	lbu	a4,0(a0)
    800030f4:	02f00793          	li	a5,47
    800030f8:	02f70363          	beq	a4,a5,8000311e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030fc:	ffffe097          	auipc	ra,0xffffe
    80003100:	dae080e7          	jalr	-594(ra) # 80000eaa <myproc>
    80003104:	15053503          	ld	a0,336(a0)
    80003108:	00000097          	auipc	ra,0x0
    8000310c:	9f6080e7          	jalr	-1546(ra) # 80002afe <idup>
    80003110:	89aa                	mv	s3,a0
  while(*path == '/')
    80003112:	02f00913          	li	s2,47
  len = path - s;
    80003116:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003118:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000311a:	4b85                	li	s7,1
    8000311c:	a865                	j	800031d4 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000311e:	4585                	li	a1,1
    80003120:	4505                	li	a0,1
    80003122:	fffff097          	auipc	ra,0xfffff
    80003126:	6e2080e7          	jalr	1762(ra) # 80002804 <iget>
    8000312a:	89aa                	mv	s3,a0
    8000312c:	b7dd                	j	80003112 <namex+0x42>
      iunlockput(ip);
    8000312e:	854e                	mv	a0,s3
    80003130:	00000097          	auipc	ra,0x0
    80003134:	c6e080e7          	jalr	-914(ra) # 80002d9e <iunlockput>
      return 0;
    80003138:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000313a:	854e                	mv	a0,s3
    8000313c:	60e6                	ld	ra,88(sp)
    8000313e:	6446                	ld	s0,80(sp)
    80003140:	64a6                	ld	s1,72(sp)
    80003142:	6906                	ld	s2,64(sp)
    80003144:	79e2                	ld	s3,56(sp)
    80003146:	7a42                	ld	s4,48(sp)
    80003148:	7aa2                	ld	s5,40(sp)
    8000314a:	7b02                	ld	s6,32(sp)
    8000314c:	6be2                	ld	s7,24(sp)
    8000314e:	6c42                	ld	s8,16(sp)
    80003150:	6ca2                	ld	s9,8(sp)
    80003152:	6125                	addi	sp,sp,96
    80003154:	8082                	ret
      iunlock(ip);
    80003156:	854e                	mv	a0,s3
    80003158:	00000097          	auipc	ra,0x0
    8000315c:	aa6080e7          	jalr	-1370(ra) # 80002bfe <iunlock>
      return ip;
    80003160:	bfe9                	j	8000313a <namex+0x6a>
      iunlockput(ip);
    80003162:	854e                	mv	a0,s3
    80003164:	00000097          	auipc	ra,0x0
    80003168:	c3a080e7          	jalr	-966(ra) # 80002d9e <iunlockput>
      return 0;
    8000316c:	89e6                	mv	s3,s9
    8000316e:	b7f1                	j	8000313a <namex+0x6a>
  len = path - s;
    80003170:	40b48633          	sub	a2,s1,a1
    80003174:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003178:	099c5463          	bge	s8,s9,80003200 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000317c:	4639                	li	a2,14
    8000317e:	8552                	mv	a0,s4
    80003180:	ffffd097          	auipc	ra,0xffffd
    80003184:	054080e7          	jalr	84(ra) # 800001d4 <memmove>
  while(*path == '/')
    80003188:	0004c783          	lbu	a5,0(s1)
    8000318c:	01279763          	bne	a5,s2,8000319a <namex+0xca>
    path++;
    80003190:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003192:	0004c783          	lbu	a5,0(s1)
    80003196:	ff278de3          	beq	a5,s2,80003190 <namex+0xc0>
    ilock(ip);
    8000319a:	854e                	mv	a0,s3
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	9a0080e7          	jalr	-1632(ra) # 80002b3c <ilock>
    if(ip->type != T_DIR){
    800031a4:	04499783          	lh	a5,68(s3)
    800031a8:	f97793e3          	bne	a5,s7,8000312e <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800031ac:	000a8563          	beqz	s5,800031b6 <namex+0xe6>
    800031b0:	0004c783          	lbu	a5,0(s1)
    800031b4:	d3cd                	beqz	a5,80003156 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031b6:	865a                	mv	a2,s6
    800031b8:	85d2                	mv	a1,s4
    800031ba:	854e                	mv	a0,s3
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	e64080e7          	jalr	-412(ra) # 80003020 <dirlookup>
    800031c4:	8caa                	mv	s9,a0
    800031c6:	dd51                	beqz	a0,80003162 <namex+0x92>
    iunlockput(ip);
    800031c8:	854e                	mv	a0,s3
    800031ca:	00000097          	auipc	ra,0x0
    800031ce:	bd4080e7          	jalr	-1068(ra) # 80002d9e <iunlockput>
    ip = next;
    800031d2:	89e6                	mv	s3,s9
  while(*path == '/')
    800031d4:	0004c783          	lbu	a5,0(s1)
    800031d8:	05279763          	bne	a5,s2,80003226 <namex+0x156>
    path++;
    800031dc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031de:	0004c783          	lbu	a5,0(s1)
    800031e2:	ff278de3          	beq	a5,s2,800031dc <namex+0x10c>
  if(*path == 0)
    800031e6:	c79d                	beqz	a5,80003214 <namex+0x144>
    path++;
    800031e8:	85a6                	mv	a1,s1
  len = path - s;
    800031ea:	8cda                	mv	s9,s6
    800031ec:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800031ee:	01278963          	beq	a5,s2,80003200 <namex+0x130>
    800031f2:	dfbd                	beqz	a5,80003170 <namex+0xa0>
    path++;
    800031f4:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800031f6:	0004c783          	lbu	a5,0(s1)
    800031fa:	ff279ce3          	bne	a5,s2,800031f2 <namex+0x122>
    800031fe:	bf8d                	j	80003170 <namex+0xa0>
    memmove(name, s, len);
    80003200:	2601                	sext.w	a2,a2
    80003202:	8552                	mv	a0,s4
    80003204:	ffffd097          	auipc	ra,0xffffd
    80003208:	fd0080e7          	jalr	-48(ra) # 800001d4 <memmove>
    name[len] = 0;
    8000320c:	9cd2                	add	s9,s9,s4
    8000320e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003212:	bf9d                	j	80003188 <namex+0xb8>
  if(nameiparent){
    80003214:	f20a83e3          	beqz	s5,8000313a <namex+0x6a>
    iput(ip);
    80003218:	854e                	mv	a0,s3
    8000321a:	00000097          	auipc	ra,0x0
    8000321e:	adc080e7          	jalr	-1316(ra) # 80002cf6 <iput>
    return 0;
    80003222:	4981                	li	s3,0
    80003224:	bf19                	j	8000313a <namex+0x6a>
  if(*path == 0)
    80003226:	d7fd                	beqz	a5,80003214 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003228:	0004c783          	lbu	a5,0(s1)
    8000322c:	85a6                	mv	a1,s1
    8000322e:	b7d1                	j	800031f2 <namex+0x122>

0000000080003230 <dirlink>:
{
    80003230:	7139                	addi	sp,sp,-64
    80003232:	fc06                	sd	ra,56(sp)
    80003234:	f822                	sd	s0,48(sp)
    80003236:	f426                	sd	s1,40(sp)
    80003238:	f04a                	sd	s2,32(sp)
    8000323a:	ec4e                	sd	s3,24(sp)
    8000323c:	e852                	sd	s4,16(sp)
    8000323e:	0080                	addi	s0,sp,64
    80003240:	892a                	mv	s2,a0
    80003242:	8a2e                	mv	s4,a1
    80003244:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003246:	4601                	li	a2,0
    80003248:	00000097          	auipc	ra,0x0
    8000324c:	dd8080e7          	jalr	-552(ra) # 80003020 <dirlookup>
    80003250:	e93d                	bnez	a0,800032c6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003252:	04c92483          	lw	s1,76(s2)
    80003256:	c49d                	beqz	s1,80003284 <dirlink+0x54>
    80003258:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000325a:	4741                	li	a4,16
    8000325c:	86a6                	mv	a3,s1
    8000325e:	fc040613          	addi	a2,s0,-64
    80003262:	4581                	li	a1,0
    80003264:	854a                	mv	a0,s2
    80003266:	00000097          	auipc	ra,0x0
    8000326a:	b8a080e7          	jalr	-1142(ra) # 80002df0 <readi>
    8000326e:	47c1                	li	a5,16
    80003270:	06f51163          	bne	a0,a5,800032d2 <dirlink+0xa2>
    if(de.inum == 0)
    80003274:	fc045783          	lhu	a5,-64(s0)
    80003278:	c791                	beqz	a5,80003284 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000327a:	24c1                	addiw	s1,s1,16
    8000327c:	04c92783          	lw	a5,76(s2)
    80003280:	fcf4ede3          	bltu	s1,a5,8000325a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003284:	4639                	li	a2,14
    80003286:	85d2                	mv	a1,s4
    80003288:	fc240513          	addi	a0,s0,-62
    8000328c:	ffffd097          	auipc	ra,0xffffd
    80003290:	ff8080e7          	jalr	-8(ra) # 80000284 <strncpy>
  de.inum = inum;
    80003294:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003298:	4741                	li	a4,16
    8000329a:	86a6                	mv	a3,s1
    8000329c:	fc040613          	addi	a2,s0,-64
    800032a0:	4581                	li	a1,0
    800032a2:	854a                	mv	a0,s2
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	c44080e7          	jalr	-956(ra) # 80002ee8 <writei>
    800032ac:	1541                	addi	a0,a0,-16
    800032ae:	00a03533          	snez	a0,a0
    800032b2:	40a00533          	neg	a0,a0
}
    800032b6:	70e2                	ld	ra,56(sp)
    800032b8:	7442                	ld	s0,48(sp)
    800032ba:	74a2                	ld	s1,40(sp)
    800032bc:	7902                	ld	s2,32(sp)
    800032be:	69e2                	ld	s3,24(sp)
    800032c0:	6a42                	ld	s4,16(sp)
    800032c2:	6121                	addi	sp,sp,64
    800032c4:	8082                	ret
    iput(ip);
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	a30080e7          	jalr	-1488(ra) # 80002cf6 <iput>
    return -1;
    800032ce:	557d                	li	a0,-1
    800032d0:	b7dd                	j	800032b6 <dirlink+0x86>
      panic("dirlink read");
    800032d2:	00005517          	auipc	a0,0x5
    800032d6:	30650513          	addi	a0,a0,774 # 800085d8 <syscalls+0x1c8>
    800032da:	00003097          	auipc	ra,0x3
    800032de:	914080e7          	jalr	-1772(ra) # 80005bee <panic>

00000000800032e2 <namei>:

struct inode*
namei(char *path)
{
    800032e2:	1101                	addi	sp,sp,-32
    800032e4:	ec06                	sd	ra,24(sp)
    800032e6:	e822                	sd	s0,16(sp)
    800032e8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032ea:	fe040613          	addi	a2,s0,-32
    800032ee:	4581                	li	a1,0
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	de0080e7          	jalr	-544(ra) # 800030d0 <namex>
}
    800032f8:	60e2                	ld	ra,24(sp)
    800032fa:	6442                	ld	s0,16(sp)
    800032fc:	6105                	addi	sp,sp,32
    800032fe:	8082                	ret

0000000080003300 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003300:	1141                	addi	sp,sp,-16
    80003302:	e406                	sd	ra,8(sp)
    80003304:	e022                	sd	s0,0(sp)
    80003306:	0800                	addi	s0,sp,16
    80003308:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000330a:	4585                	li	a1,1
    8000330c:	00000097          	auipc	ra,0x0
    80003310:	dc4080e7          	jalr	-572(ra) # 800030d0 <namex>
}
    80003314:	60a2                	ld	ra,8(sp)
    80003316:	6402                	ld	s0,0(sp)
    80003318:	0141                	addi	sp,sp,16
    8000331a:	8082                	ret

000000008000331c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000331c:	1101                	addi	sp,sp,-32
    8000331e:	ec06                	sd	ra,24(sp)
    80003320:	e822                	sd	s0,16(sp)
    80003322:	e426                	sd	s1,8(sp)
    80003324:	e04a                	sd	s2,0(sp)
    80003326:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003328:	00015917          	auipc	s2,0x15
    8000332c:	5c890913          	addi	s2,s2,1480 # 800188f0 <log>
    80003330:	01892583          	lw	a1,24(s2)
    80003334:	02892503          	lw	a0,40(s2)
    80003338:	fffff097          	auipc	ra,0xfffff
    8000333c:	fea080e7          	jalr	-22(ra) # 80002322 <bread>
    80003340:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003342:	02c92683          	lw	a3,44(s2)
    80003346:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003348:	02d05763          	blez	a3,80003376 <write_head+0x5a>
    8000334c:	00015797          	auipc	a5,0x15
    80003350:	5d478793          	addi	a5,a5,1492 # 80018920 <log+0x30>
    80003354:	05c50713          	addi	a4,a0,92
    80003358:	36fd                	addiw	a3,a3,-1
    8000335a:	1682                	slli	a3,a3,0x20
    8000335c:	9281                	srli	a3,a3,0x20
    8000335e:	068a                	slli	a3,a3,0x2
    80003360:	00015617          	auipc	a2,0x15
    80003364:	5c460613          	addi	a2,a2,1476 # 80018924 <log+0x34>
    80003368:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000336a:	4390                	lw	a2,0(a5)
    8000336c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000336e:	0791                	addi	a5,a5,4
    80003370:	0711                	addi	a4,a4,4
    80003372:	fed79ce3          	bne	a5,a3,8000336a <write_head+0x4e>
  }
  bwrite(buf);
    80003376:	8526                	mv	a0,s1
    80003378:	fffff097          	auipc	ra,0xfffff
    8000337c:	09c080e7          	jalr	156(ra) # 80002414 <bwrite>
  brelse(buf);
    80003380:	8526                	mv	a0,s1
    80003382:	fffff097          	auipc	ra,0xfffff
    80003386:	0d0080e7          	jalr	208(ra) # 80002452 <brelse>
}
    8000338a:	60e2                	ld	ra,24(sp)
    8000338c:	6442                	ld	s0,16(sp)
    8000338e:	64a2                	ld	s1,8(sp)
    80003390:	6902                	ld	s2,0(sp)
    80003392:	6105                	addi	sp,sp,32
    80003394:	8082                	ret

0000000080003396 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003396:	00015797          	auipc	a5,0x15
    8000339a:	5867a783          	lw	a5,1414(a5) # 8001891c <log+0x2c>
    8000339e:	0af05d63          	blez	a5,80003458 <install_trans+0xc2>
{
    800033a2:	7139                	addi	sp,sp,-64
    800033a4:	fc06                	sd	ra,56(sp)
    800033a6:	f822                	sd	s0,48(sp)
    800033a8:	f426                	sd	s1,40(sp)
    800033aa:	f04a                	sd	s2,32(sp)
    800033ac:	ec4e                	sd	s3,24(sp)
    800033ae:	e852                	sd	s4,16(sp)
    800033b0:	e456                	sd	s5,8(sp)
    800033b2:	e05a                	sd	s6,0(sp)
    800033b4:	0080                	addi	s0,sp,64
    800033b6:	8b2a                	mv	s6,a0
    800033b8:	00015a97          	auipc	s5,0x15
    800033bc:	568a8a93          	addi	s5,s5,1384 # 80018920 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033c0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033c2:	00015997          	auipc	s3,0x15
    800033c6:	52e98993          	addi	s3,s3,1326 # 800188f0 <log>
    800033ca:	a00d                	j	800033ec <install_trans+0x56>
    brelse(lbuf);
    800033cc:	854a                	mv	a0,s2
    800033ce:	fffff097          	auipc	ra,0xfffff
    800033d2:	084080e7          	jalr	132(ra) # 80002452 <brelse>
    brelse(dbuf);
    800033d6:	8526                	mv	a0,s1
    800033d8:	fffff097          	auipc	ra,0xfffff
    800033dc:	07a080e7          	jalr	122(ra) # 80002452 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033e0:	2a05                	addiw	s4,s4,1
    800033e2:	0a91                	addi	s5,s5,4
    800033e4:	02c9a783          	lw	a5,44(s3)
    800033e8:	04fa5e63          	bge	s4,a5,80003444 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033ec:	0189a583          	lw	a1,24(s3)
    800033f0:	014585bb          	addw	a1,a1,s4
    800033f4:	2585                	addiw	a1,a1,1
    800033f6:	0289a503          	lw	a0,40(s3)
    800033fa:	fffff097          	auipc	ra,0xfffff
    800033fe:	f28080e7          	jalr	-216(ra) # 80002322 <bread>
    80003402:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003404:	000aa583          	lw	a1,0(s5)
    80003408:	0289a503          	lw	a0,40(s3)
    8000340c:	fffff097          	auipc	ra,0xfffff
    80003410:	f16080e7          	jalr	-234(ra) # 80002322 <bread>
    80003414:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003416:	40000613          	li	a2,1024
    8000341a:	05890593          	addi	a1,s2,88
    8000341e:	05850513          	addi	a0,a0,88
    80003422:	ffffd097          	auipc	ra,0xffffd
    80003426:	db2080e7          	jalr	-590(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000342a:	8526                	mv	a0,s1
    8000342c:	fffff097          	auipc	ra,0xfffff
    80003430:	fe8080e7          	jalr	-24(ra) # 80002414 <bwrite>
    if(recovering == 0)
    80003434:	f80b1ce3          	bnez	s6,800033cc <install_trans+0x36>
      bunpin(dbuf);
    80003438:	8526                	mv	a0,s1
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	0f2080e7          	jalr	242(ra) # 8000252c <bunpin>
    80003442:	b769                	j	800033cc <install_trans+0x36>
}
    80003444:	70e2                	ld	ra,56(sp)
    80003446:	7442                	ld	s0,48(sp)
    80003448:	74a2                	ld	s1,40(sp)
    8000344a:	7902                	ld	s2,32(sp)
    8000344c:	69e2                	ld	s3,24(sp)
    8000344e:	6a42                	ld	s4,16(sp)
    80003450:	6aa2                	ld	s5,8(sp)
    80003452:	6b02                	ld	s6,0(sp)
    80003454:	6121                	addi	sp,sp,64
    80003456:	8082                	ret
    80003458:	8082                	ret

000000008000345a <initlog>:
{
    8000345a:	7179                	addi	sp,sp,-48
    8000345c:	f406                	sd	ra,40(sp)
    8000345e:	f022                	sd	s0,32(sp)
    80003460:	ec26                	sd	s1,24(sp)
    80003462:	e84a                	sd	s2,16(sp)
    80003464:	e44e                	sd	s3,8(sp)
    80003466:	1800                	addi	s0,sp,48
    80003468:	892a                	mv	s2,a0
    8000346a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000346c:	00015497          	auipc	s1,0x15
    80003470:	48448493          	addi	s1,s1,1156 # 800188f0 <log>
    80003474:	00005597          	auipc	a1,0x5
    80003478:	17458593          	addi	a1,a1,372 # 800085e8 <syscalls+0x1d8>
    8000347c:	8526                	mv	a0,s1
    8000347e:	00003097          	auipc	ra,0x3
    80003482:	c1c080e7          	jalr	-996(ra) # 8000609a <initlock>
  log.start = sb->logstart;
    80003486:	0149a583          	lw	a1,20(s3)
    8000348a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000348c:	0109a783          	lw	a5,16(s3)
    80003490:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003492:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003496:	854a                	mv	a0,s2
    80003498:	fffff097          	auipc	ra,0xfffff
    8000349c:	e8a080e7          	jalr	-374(ra) # 80002322 <bread>
  log.lh.n = lh->n;
    800034a0:	4d34                	lw	a3,88(a0)
    800034a2:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034a4:	02d05563          	blez	a3,800034ce <initlog+0x74>
    800034a8:	05c50793          	addi	a5,a0,92
    800034ac:	00015717          	auipc	a4,0x15
    800034b0:	47470713          	addi	a4,a4,1140 # 80018920 <log+0x30>
    800034b4:	36fd                	addiw	a3,a3,-1
    800034b6:	1682                	slli	a3,a3,0x20
    800034b8:	9281                	srli	a3,a3,0x20
    800034ba:	068a                	slli	a3,a3,0x2
    800034bc:	06050613          	addi	a2,a0,96
    800034c0:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800034c2:	4390                	lw	a2,0(a5)
    800034c4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034c6:	0791                	addi	a5,a5,4
    800034c8:	0711                	addi	a4,a4,4
    800034ca:	fed79ce3          	bne	a5,a3,800034c2 <initlog+0x68>
  brelse(buf);
    800034ce:	fffff097          	auipc	ra,0xfffff
    800034d2:	f84080e7          	jalr	-124(ra) # 80002452 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034d6:	4505                	li	a0,1
    800034d8:	00000097          	auipc	ra,0x0
    800034dc:	ebe080e7          	jalr	-322(ra) # 80003396 <install_trans>
  log.lh.n = 0;
    800034e0:	00015797          	auipc	a5,0x15
    800034e4:	4207ae23          	sw	zero,1084(a5) # 8001891c <log+0x2c>
  write_head(); // clear the log
    800034e8:	00000097          	auipc	ra,0x0
    800034ec:	e34080e7          	jalr	-460(ra) # 8000331c <write_head>
}
    800034f0:	70a2                	ld	ra,40(sp)
    800034f2:	7402                	ld	s0,32(sp)
    800034f4:	64e2                	ld	s1,24(sp)
    800034f6:	6942                	ld	s2,16(sp)
    800034f8:	69a2                	ld	s3,8(sp)
    800034fa:	6145                	addi	sp,sp,48
    800034fc:	8082                	ret

00000000800034fe <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034fe:	1101                	addi	sp,sp,-32
    80003500:	ec06                	sd	ra,24(sp)
    80003502:	e822                	sd	s0,16(sp)
    80003504:	e426                	sd	s1,8(sp)
    80003506:	e04a                	sd	s2,0(sp)
    80003508:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000350a:	00015517          	auipc	a0,0x15
    8000350e:	3e650513          	addi	a0,a0,998 # 800188f0 <log>
    80003512:	00003097          	auipc	ra,0x3
    80003516:	c18080e7          	jalr	-1000(ra) # 8000612a <acquire>
  while(1){
    if(log.committing){
    8000351a:	00015497          	auipc	s1,0x15
    8000351e:	3d648493          	addi	s1,s1,982 # 800188f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003522:	4979                	li	s2,30
    80003524:	a039                	j	80003532 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003526:	85a6                	mv	a1,s1
    80003528:	8526                	mv	a0,s1
    8000352a:	ffffe097          	auipc	ra,0xffffe
    8000352e:	02c080e7          	jalr	44(ra) # 80001556 <sleep>
    if(log.committing){
    80003532:	50dc                	lw	a5,36(s1)
    80003534:	fbed                	bnez	a5,80003526 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003536:	509c                	lw	a5,32(s1)
    80003538:	0017871b          	addiw	a4,a5,1
    8000353c:	0007069b          	sext.w	a3,a4
    80003540:	0027179b          	slliw	a5,a4,0x2
    80003544:	9fb9                	addw	a5,a5,a4
    80003546:	0017979b          	slliw	a5,a5,0x1
    8000354a:	54d8                	lw	a4,44(s1)
    8000354c:	9fb9                	addw	a5,a5,a4
    8000354e:	00f95963          	bge	s2,a5,80003560 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003552:	85a6                	mv	a1,s1
    80003554:	8526                	mv	a0,s1
    80003556:	ffffe097          	auipc	ra,0xffffe
    8000355a:	000080e7          	jalr	ra # 80001556 <sleep>
    8000355e:	bfd1                	j	80003532 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003560:	00015517          	auipc	a0,0x15
    80003564:	39050513          	addi	a0,a0,912 # 800188f0 <log>
    80003568:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000356a:	00003097          	auipc	ra,0x3
    8000356e:	c74080e7          	jalr	-908(ra) # 800061de <release>
      break;
    }
  }
}
    80003572:	60e2                	ld	ra,24(sp)
    80003574:	6442                	ld	s0,16(sp)
    80003576:	64a2                	ld	s1,8(sp)
    80003578:	6902                	ld	s2,0(sp)
    8000357a:	6105                	addi	sp,sp,32
    8000357c:	8082                	ret

000000008000357e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000357e:	7139                	addi	sp,sp,-64
    80003580:	fc06                	sd	ra,56(sp)
    80003582:	f822                	sd	s0,48(sp)
    80003584:	f426                	sd	s1,40(sp)
    80003586:	f04a                	sd	s2,32(sp)
    80003588:	ec4e                	sd	s3,24(sp)
    8000358a:	e852                	sd	s4,16(sp)
    8000358c:	e456                	sd	s5,8(sp)
    8000358e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003590:	00015497          	auipc	s1,0x15
    80003594:	36048493          	addi	s1,s1,864 # 800188f0 <log>
    80003598:	8526                	mv	a0,s1
    8000359a:	00003097          	auipc	ra,0x3
    8000359e:	b90080e7          	jalr	-1136(ra) # 8000612a <acquire>
  log.outstanding -= 1;
    800035a2:	509c                	lw	a5,32(s1)
    800035a4:	37fd                	addiw	a5,a5,-1
    800035a6:	0007891b          	sext.w	s2,a5
    800035aa:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035ac:	50dc                	lw	a5,36(s1)
    800035ae:	e7b9                	bnez	a5,800035fc <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800035b0:	04091e63          	bnez	s2,8000360c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800035b4:	00015497          	auipc	s1,0x15
    800035b8:	33c48493          	addi	s1,s1,828 # 800188f0 <log>
    800035bc:	4785                	li	a5,1
    800035be:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035c0:	8526                	mv	a0,s1
    800035c2:	00003097          	auipc	ra,0x3
    800035c6:	c1c080e7          	jalr	-996(ra) # 800061de <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035ca:	54dc                	lw	a5,44(s1)
    800035cc:	06f04763          	bgtz	a5,8000363a <end_op+0xbc>
    acquire(&log.lock);
    800035d0:	00015497          	auipc	s1,0x15
    800035d4:	32048493          	addi	s1,s1,800 # 800188f0 <log>
    800035d8:	8526                	mv	a0,s1
    800035da:	00003097          	auipc	ra,0x3
    800035de:	b50080e7          	jalr	-1200(ra) # 8000612a <acquire>
    log.committing = 0;
    800035e2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035e6:	8526                	mv	a0,s1
    800035e8:	ffffe097          	auipc	ra,0xffffe
    800035ec:	fd2080e7          	jalr	-46(ra) # 800015ba <wakeup>
    release(&log.lock);
    800035f0:	8526                	mv	a0,s1
    800035f2:	00003097          	auipc	ra,0x3
    800035f6:	bec080e7          	jalr	-1044(ra) # 800061de <release>
}
    800035fa:	a03d                	j	80003628 <end_op+0xaa>
    panic("log.committing");
    800035fc:	00005517          	auipc	a0,0x5
    80003600:	ff450513          	addi	a0,a0,-12 # 800085f0 <syscalls+0x1e0>
    80003604:	00002097          	auipc	ra,0x2
    80003608:	5ea080e7          	jalr	1514(ra) # 80005bee <panic>
    wakeup(&log);
    8000360c:	00015497          	auipc	s1,0x15
    80003610:	2e448493          	addi	s1,s1,740 # 800188f0 <log>
    80003614:	8526                	mv	a0,s1
    80003616:	ffffe097          	auipc	ra,0xffffe
    8000361a:	fa4080e7          	jalr	-92(ra) # 800015ba <wakeup>
  release(&log.lock);
    8000361e:	8526                	mv	a0,s1
    80003620:	00003097          	auipc	ra,0x3
    80003624:	bbe080e7          	jalr	-1090(ra) # 800061de <release>
}
    80003628:	70e2                	ld	ra,56(sp)
    8000362a:	7442                	ld	s0,48(sp)
    8000362c:	74a2                	ld	s1,40(sp)
    8000362e:	7902                	ld	s2,32(sp)
    80003630:	69e2                	ld	s3,24(sp)
    80003632:	6a42                	ld	s4,16(sp)
    80003634:	6aa2                	ld	s5,8(sp)
    80003636:	6121                	addi	sp,sp,64
    80003638:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000363a:	00015a97          	auipc	s5,0x15
    8000363e:	2e6a8a93          	addi	s5,s5,742 # 80018920 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003642:	00015a17          	auipc	s4,0x15
    80003646:	2aea0a13          	addi	s4,s4,686 # 800188f0 <log>
    8000364a:	018a2583          	lw	a1,24(s4)
    8000364e:	012585bb          	addw	a1,a1,s2
    80003652:	2585                	addiw	a1,a1,1
    80003654:	028a2503          	lw	a0,40(s4)
    80003658:	fffff097          	auipc	ra,0xfffff
    8000365c:	cca080e7          	jalr	-822(ra) # 80002322 <bread>
    80003660:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003662:	000aa583          	lw	a1,0(s5)
    80003666:	028a2503          	lw	a0,40(s4)
    8000366a:	fffff097          	auipc	ra,0xfffff
    8000366e:	cb8080e7          	jalr	-840(ra) # 80002322 <bread>
    80003672:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003674:	40000613          	li	a2,1024
    80003678:	05850593          	addi	a1,a0,88
    8000367c:	05848513          	addi	a0,s1,88
    80003680:	ffffd097          	auipc	ra,0xffffd
    80003684:	b54080e7          	jalr	-1196(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    80003688:	8526                	mv	a0,s1
    8000368a:	fffff097          	auipc	ra,0xfffff
    8000368e:	d8a080e7          	jalr	-630(ra) # 80002414 <bwrite>
    brelse(from);
    80003692:	854e                	mv	a0,s3
    80003694:	fffff097          	auipc	ra,0xfffff
    80003698:	dbe080e7          	jalr	-578(ra) # 80002452 <brelse>
    brelse(to);
    8000369c:	8526                	mv	a0,s1
    8000369e:	fffff097          	auipc	ra,0xfffff
    800036a2:	db4080e7          	jalr	-588(ra) # 80002452 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a6:	2905                	addiw	s2,s2,1
    800036a8:	0a91                	addi	s5,s5,4
    800036aa:	02ca2783          	lw	a5,44(s4)
    800036ae:	f8f94ee3          	blt	s2,a5,8000364a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036b2:	00000097          	auipc	ra,0x0
    800036b6:	c6a080e7          	jalr	-918(ra) # 8000331c <write_head>
    install_trans(0); // Now install writes to home locations
    800036ba:	4501                	li	a0,0
    800036bc:	00000097          	auipc	ra,0x0
    800036c0:	cda080e7          	jalr	-806(ra) # 80003396 <install_trans>
    log.lh.n = 0;
    800036c4:	00015797          	auipc	a5,0x15
    800036c8:	2407ac23          	sw	zero,600(a5) # 8001891c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036cc:	00000097          	auipc	ra,0x0
    800036d0:	c50080e7          	jalr	-944(ra) # 8000331c <write_head>
    800036d4:	bdf5                	j	800035d0 <end_op+0x52>

00000000800036d6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036d6:	1101                	addi	sp,sp,-32
    800036d8:	ec06                	sd	ra,24(sp)
    800036da:	e822                	sd	s0,16(sp)
    800036dc:	e426                	sd	s1,8(sp)
    800036de:	e04a                	sd	s2,0(sp)
    800036e0:	1000                	addi	s0,sp,32
    800036e2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036e4:	00015917          	auipc	s2,0x15
    800036e8:	20c90913          	addi	s2,s2,524 # 800188f0 <log>
    800036ec:	854a                	mv	a0,s2
    800036ee:	00003097          	auipc	ra,0x3
    800036f2:	a3c080e7          	jalr	-1476(ra) # 8000612a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036f6:	02c92603          	lw	a2,44(s2)
    800036fa:	47f5                	li	a5,29
    800036fc:	06c7c563          	blt	a5,a2,80003766 <log_write+0x90>
    80003700:	00015797          	auipc	a5,0x15
    80003704:	20c7a783          	lw	a5,524(a5) # 8001890c <log+0x1c>
    80003708:	37fd                	addiw	a5,a5,-1
    8000370a:	04f65e63          	bge	a2,a5,80003766 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000370e:	00015797          	auipc	a5,0x15
    80003712:	2027a783          	lw	a5,514(a5) # 80018910 <log+0x20>
    80003716:	06f05063          	blez	a5,80003776 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000371a:	4781                	li	a5,0
    8000371c:	06c05563          	blez	a2,80003786 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003720:	44cc                	lw	a1,12(s1)
    80003722:	00015717          	auipc	a4,0x15
    80003726:	1fe70713          	addi	a4,a4,510 # 80018920 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000372a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000372c:	4314                	lw	a3,0(a4)
    8000372e:	04b68c63          	beq	a3,a1,80003786 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003732:	2785                	addiw	a5,a5,1
    80003734:	0711                	addi	a4,a4,4
    80003736:	fef61be3          	bne	a2,a5,8000372c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000373a:	0621                	addi	a2,a2,8
    8000373c:	060a                	slli	a2,a2,0x2
    8000373e:	00015797          	auipc	a5,0x15
    80003742:	1b278793          	addi	a5,a5,434 # 800188f0 <log>
    80003746:	963e                	add	a2,a2,a5
    80003748:	44dc                	lw	a5,12(s1)
    8000374a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000374c:	8526                	mv	a0,s1
    8000374e:	fffff097          	auipc	ra,0xfffff
    80003752:	da2080e7          	jalr	-606(ra) # 800024f0 <bpin>
    log.lh.n++;
    80003756:	00015717          	auipc	a4,0x15
    8000375a:	19a70713          	addi	a4,a4,410 # 800188f0 <log>
    8000375e:	575c                	lw	a5,44(a4)
    80003760:	2785                	addiw	a5,a5,1
    80003762:	d75c                	sw	a5,44(a4)
    80003764:	a835                	j	800037a0 <log_write+0xca>
    panic("too big a transaction");
    80003766:	00005517          	auipc	a0,0x5
    8000376a:	e9a50513          	addi	a0,a0,-358 # 80008600 <syscalls+0x1f0>
    8000376e:	00002097          	auipc	ra,0x2
    80003772:	480080e7          	jalr	1152(ra) # 80005bee <panic>
    panic("log_write outside of trans");
    80003776:	00005517          	auipc	a0,0x5
    8000377a:	ea250513          	addi	a0,a0,-350 # 80008618 <syscalls+0x208>
    8000377e:	00002097          	auipc	ra,0x2
    80003782:	470080e7          	jalr	1136(ra) # 80005bee <panic>
  log.lh.block[i] = b->blockno;
    80003786:	00878713          	addi	a4,a5,8
    8000378a:	00271693          	slli	a3,a4,0x2
    8000378e:	00015717          	auipc	a4,0x15
    80003792:	16270713          	addi	a4,a4,354 # 800188f0 <log>
    80003796:	9736                	add	a4,a4,a3
    80003798:	44d4                	lw	a3,12(s1)
    8000379a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000379c:	faf608e3          	beq	a2,a5,8000374c <log_write+0x76>
  }
  release(&log.lock);
    800037a0:	00015517          	auipc	a0,0x15
    800037a4:	15050513          	addi	a0,a0,336 # 800188f0 <log>
    800037a8:	00003097          	auipc	ra,0x3
    800037ac:	a36080e7          	jalr	-1482(ra) # 800061de <release>
}
    800037b0:	60e2                	ld	ra,24(sp)
    800037b2:	6442                	ld	s0,16(sp)
    800037b4:	64a2                	ld	s1,8(sp)
    800037b6:	6902                	ld	s2,0(sp)
    800037b8:	6105                	addi	sp,sp,32
    800037ba:	8082                	ret

00000000800037bc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037bc:	1101                	addi	sp,sp,-32
    800037be:	ec06                	sd	ra,24(sp)
    800037c0:	e822                	sd	s0,16(sp)
    800037c2:	e426                	sd	s1,8(sp)
    800037c4:	e04a                	sd	s2,0(sp)
    800037c6:	1000                	addi	s0,sp,32
    800037c8:	84aa                	mv	s1,a0
    800037ca:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037cc:	00005597          	auipc	a1,0x5
    800037d0:	e6c58593          	addi	a1,a1,-404 # 80008638 <syscalls+0x228>
    800037d4:	0521                	addi	a0,a0,8
    800037d6:	00003097          	auipc	ra,0x3
    800037da:	8c4080e7          	jalr	-1852(ra) # 8000609a <initlock>
  lk->name = name;
    800037de:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037e2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037e6:	0204a423          	sw	zero,40(s1)
}
    800037ea:	60e2                	ld	ra,24(sp)
    800037ec:	6442                	ld	s0,16(sp)
    800037ee:	64a2                	ld	s1,8(sp)
    800037f0:	6902                	ld	s2,0(sp)
    800037f2:	6105                	addi	sp,sp,32
    800037f4:	8082                	ret

00000000800037f6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037f6:	1101                	addi	sp,sp,-32
    800037f8:	ec06                	sd	ra,24(sp)
    800037fa:	e822                	sd	s0,16(sp)
    800037fc:	e426                	sd	s1,8(sp)
    800037fe:	e04a                	sd	s2,0(sp)
    80003800:	1000                	addi	s0,sp,32
    80003802:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003804:	00850913          	addi	s2,a0,8
    80003808:	854a                	mv	a0,s2
    8000380a:	00003097          	auipc	ra,0x3
    8000380e:	920080e7          	jalr	-1760(ra) # 8000612a <acquire>
  while (lk->locked) {
    80003812:	409c                	lw	a5,0(s1)
    80003814:	cb89                	beqz	a5,80003826 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003816:	85ca                	mv	a1,s2
    80003818:	8526                	mv	a0,s1
    8000381a:	ffffe097          	auipc	ra,0xffffe
    8000381e:	d3c080e7          	jalr	-708(ra) # 80001556 <sleep>
  while (lk->locked) {
    80003822:	409c                	lw	a5,0(s1)
    80003824:	fbed                	bnez	a5,80003816 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003826:	4785                	li	a5,1
    80003828:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000382a:	ffffd097          	auipc	ra,0xffffd
    8000382e:	680080e7          	jalr	1664(ra) # 80000eaa <myproc>
    80003832:	591c                	lw	a5,48(a0)
    80003834:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003836:	854a                	mv	a0,s2
    80003838:	00003097          	auipc	ra,0x3
    8000383c:	9a6080e7          	jalr	-1626(ra) # 800061de <release>
}
    80003840:	60e2                	ld	ra,24(sp)
    80003842:	6442                	ld	s0,16(sp)
    80003844:	64a2                	ld	s1,8(sp)
    80003846:	6902                	ld	s2,0(sp)
    80003848:	6105                	addi	sp,sp,32
    8000384a:	8082                	ret

000000008000384c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000384c:	1101                	addi	sp,sp,-32
    8000384e:	ec06                	sd	ra,24(sp)
    80003850:	e822                	sd	s0,16(sp)
    80003852:	e426                	sd	s1,8(sp)
    80003854:	e04a                	sd	s2,0(sp)
    80003856:	1000                	addi	s0,sp,32
    80003858:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000385a:	00850913          	addi	s2,a0,8
    8000385e:	854a                	mv	a0,s2
    80003860:	00003097          	auipc	ra,0x3
    80003864:	8ca080e7          	jalr	-1846(ra) # 8000612a <acquire>
  lk->locked = 0;
    80003868:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000386c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003870:	8526                	mv	a0,s1
    80003872:	ffffe097          	auipc	ra,0xffffe
    80003876:	d48080e7          	jalr	-696(ra) # 800015ba <wakeup>
  release(&lk->lk);
    8000387a:	854a                	mv	a0,s2
    8000387c:	00003097          	auipc	ra,0x3
    80003880:	962080e7          	jalr	-1694(ra) # 800061de <release>
}
    80003884:	60e2                	ld	ra,24(sp)
    80003886:	6442                	ld	s0,16(sp)
    80003888:	64a2                	ld	s1,8(sp)
    8000388a:	6902                	ld	s2,0(sp)
    8000388c:	6105                	addi	sp,sp,32
    8000388e:	8082                	ret

0000000080003890 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003890:	7179                	addi	sp,sp,-48
    80003892:	f406                	sd	ra,40(sp)
    80003894:	f022                	sd	s0,32(sp)
    80003896:	ec26                	sd	s1,24(sp)
    80003898:	e84a                	sd	s2,16(sp)
    8000389a:	e44e                	sd	s3,8(sp)
    8000389c:	1800                	addi	s0,sp,48
    8000389e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038a0:	00850913          	addi	s2,a0,8
    800038a4:	854a                	mv	a0,s2
    800038a6:	00003097          	auipc	ra,0x3
    800038aa:	884080e7          	jalr	-1916(ra) # 8000612a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038ae:	409c                	lw	a5,0(s1)
    800038b0:	ef99                	bnez	a5,800038ce <holdingsleep+0x3e>
    800038b2:	4481                	li	s1,0
  release(&lk->lk);
    800038b4:	854a                	mv	a0,s2
    800038b6:	00003097          	auipc	ra,0x3
    800038ba:	928080e7          	jalr	-1752(ra) # 800061de <release>
  return r;
}
    800038be:	8526                	mv	a0,s1
    800038c0:	70a2                	ld	ra,40(sp)
    800038c2:	7402                	ld	s0,32(sp)
    800038c4:	64e2                	ld	s1,24(sp)
    800038c6:	6942                	ld	s2,16(sp)
    800038c8:	69a2                	ld	s3,8(sp)
    800038ca:	6145                	addi	sp,sp,48
    800038cc:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800038ce:	0284a983          	lw	s3,40(s1)
    800038d2:	ffffd097          	auipc	ra,0xffffd
    800038d6:	5d8080e7          	jalr	1496(ra) # 80000eaa <myproc>
    800038da:	5904                	lw	s1,48(a0)
    800038dc:	413484b3          	sub	s1,s1,s3
    800038e0:	0014b493          	seqz	s1,s1
    800038e4:	bfc1                	j	800038b4 <holdingsleep+0x24>

00000000800038e6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038e6:	1141                	addi	sp,sp,-16
    800038e8:	e406                	sd	ra,8(sp)
    800038ea:	e022                	sd	s0,0(sp)
    800038ec:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038ee:	00005597          	auipc	a1,0x5
    800038f2:	d5a58593          	addi	a1,a1,-678 # 80008648 <syscalls+0x238>
    800038f6:	00015517          	auipc	a0,0x15
    800038fa:	14250513          	addi	a0,a0,322 # 80018a38 <ftable>
    800038fe:	00002097          	auipc	ra,0x2
    80003902:	79c080e7          	jalr	1948(ra) # 8000609a <initlock>
}
    80003906:	60a2                	ld	ra,8(sp)
    80003908:	6402                	ld	s0,0(sp)
    8000390a:	0141                	addi	sp,sp,16
    8000390c:	8082                	ret

000000008000390e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000390e:	1101                	addi	sp,sp,-32
    80003910:	ec06                	sd	ra,24(sp)
    80003912:	e822                	sd	s0,16(sp)
    80003914:	e426                	sd	s1,8(sp)
    80003916:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003918:	00015517          	auipc	a0,0x15
    8000391c:	12050513          	addi	a0,a0,288 # 80018a38 <ftable>
    80003920:	00003097          	auipc	ra,0x3
    80003924:	80a080e7          	jalr	-2038(ra) # 8000612a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003928:	00015497          	auipc	s1,0x15
    8000392c:	12848493          	addi	s1,s1,296 # 80018a50 <ftable+0x18>
    80003930:	00016717          	auipc	a4,0x16
    80003934:	0c070713          	addi	a4,a4,192 # 800199f0 <disk>
    if(f->ref == 0){
    80003938:	40dc                	lw	a5,4(s1)
    8000393a:	cf99                	beqz	a5,80003958 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000393c:	02848493          	addi	s1,s1,40
    80003940:	fee49ce3          	bne	s1,a4,80003938 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003944:	00015517          	auipc	a0,0x15
    80003948:	0f450513          	addi	a0,a0,244 # 80018a38 <ftable>
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	892080e7          	jalr	-1902(ra) # 800061de <release>
  return 0;
    80003954:	4481                	li	s1,0
    80003956:	a819                	j	8000396c <filealloc+0x5e>
      f->ref = 1;
    80003958:	4785                	li	a5,1
    8000395a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000395c:	00015517          	auipc	a0,0x15
    80003960:	0dc50513          	addi	a0,a0,220 # 80018a38 <ftable>
    80003964:	00003097          	auipc	ra,0x3
    80003968:	87a080e7          	jalr	-1926(ra) # 800061de <release>
}
    8000396c:	8526                	mv	a0,s1
    8000396e:	60e2                	ld	ra,24(sp)
    80003970:	6442                	ld	s0,16(sp)
    80003972:	64a2                	ld	s1,8(sp)
    80003974:	6105                	addi	sp,sp,32
    80003976:	8082                	ret

0000000080003978 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003978:	1101                	addi	sp,sp,-32
    8000397a:	ec06                	sd	ra,24(sp)
    8000397c:	e822                	sd	s0,16(sp)
    8000397e:	e426                	sd	s1,8(sp)
    80003980:	1000                	addi	s0,sp,32
    80003982:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003984:	00015517          	auipc	a0,0x15
    80003988:	0b450513          	addi	a0,a0,180 # 80018a38 <ftable>
    8000398c:	00002097          	auipc	ra,0x2
    80003990:	79e080e7          	jalr	1950(ra) # 8000612a <acquire>
  if(f->ref < 1)
    80003994:	40dc                	lw	a5,4(s1)
    80003996:	02f05263          	blez	a5,800039ba <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000399a:	2785                	addiw	a5,a5,1
    8000399c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000399e:	00015517          	auipc	a0,0x15
    800039a2:	09a50513          	addi	a0,a0,154 # 80018a38 <ftable>
    800039a6:	00003097          	auipc	ra,0x3
    800039aa:	838080e7          	jalr	-1992(ra) # 800061de <release>
  return f;
}
    800039ae:	8526                	mv	a0,s1
    800039b0:	60e2                	ld	ra,24(sp)
    800039b2:	6442                	ld	s0,16(sp)
    800039b4:	64a2                	ld	s1,8(sp)
    800039b6:	6105                	addi	sp,sp,32
    800039b8:	8082                	ret
    panic("filedup");
    800039ba:	00005517          	auipc	a0,0x5
    800039be:	c9650513          	addi	a0,a0,-874 # 80008650 <syscalls+0x240>
    800039c2:	00002097          	auipc	ra,0x2
    800039c6:	22c080e7          	jalr	556(ra) # 80005bee <panic>

00000000800039ca <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039ca:	7139                	addi	sp,sp,-64
    800039cc:	fc06                	sd	ra,56(sp)
    800039ce:	f822                	sd	s0,48(sp)
    800039d0:	f426                	sd	s1,40(sp)
    800039d2:	f04a                	sd	s2,32(sp)
    800039d4:	ec4e                	sd	s3,24(sp)
    800039d6:	e852                	sd	s4,16(sp)
    800039d8:	e456                	sd	s5,8(sp)
    800039da:	0080                	addi	s0,sp,64
    800039dc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039de:	00015517          	auipc	a0,0x15
    800039e2:	05a50513          	addi	a0,a0,90 # 80018a38 <ftable>
    800039e6:	00002097          	auipc	ra,0x2
    800039ea:	744080e7          	jalr	1860(ra) # 8000612a <acquire>
  if(f->ref < 1)
    800039ee:	40dc                	lw	a5,4(s1)
    800039f0:	06f05163          	blez	a5,80003a52 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800039f4:	37fd                	addiw	a5,a5,-1
    800039f6:	0007871b          	sext.w	a4,a5
    800039fa:	c0dc                	sw	a5,4(s1)
    800039fc:	06e04363          	bgtz	a4,80003a62 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a00:	0004a903          	lw	s2,0(s1)
    80003a04:	0094ca83          	lbu	s5,9(s1)
    80003a08:	0104ba03          	ld	s4,16(s1)
    80003a0c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a10:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a14:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a18:	00015517          	auipc	a0,0x15
    80003a1c:	02050513          	addi	a0,a0,32 # 80018a38 <ftable>
    80003a20:	00002097          	auipc	ra,0x2
    80003a24:	7be080e7          	jalr	1982(ra) # 800061de <release>

  if(ff.type == FD_PIPE){
    80003a28:	4785                	li	a5,1
    80003a2a:	04f90d63          	beq	s2,a5,80003a84 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a2e:	3979                	addiw	s2,s2,-2
    80003a30:	4785                	li	a5,1
    80003a32:	0527e063          	bltu	a5,s2,80003a72 <fileclose+0xa8>
    begin_op();
    80003a36:	00000097          	auipc	ra,0x0
    80003a3a:	ac8080e7          	jalr	-1336(ra) # 800034fe <begin_op>
    iput(ff.ip);
    80003a3e:	854e                	mv	a0,s3
    80003a40:	fffff097          	auipc	ra,0xfffff
    80003a44:	2b6080e7          	jalr	694(ra) # 80002cf6 <iput>
    end_op();
    80003a48:	00000097          	auipc	ra,0x0
    80003a4c:	b36080e7          	jalr	-1226(ra) # 8000357e <end_op>
    80003a50:	a00d                	j	80003a72 <fileclose+0xa8>
    panic("fileclose");
    80003a52:	00005517          	auipc	a0,0x5
    80003a56:	c0650513          	addi	a0,a0,-1018 # 80008658 <syscalls+0x248>
    80003a5a:	00002097          	auipc	ra,0x2
    80003a5e:	194080e7          	jalr	404(ra) # 80005bee <panic>
    release(&ftable.lock);
    80003a62:	00015517          	auipc	a0,0x15
    80003a66:	fd650513          	addi	a0,a0,-42 # 80018a38 <ftable>
    80003a6a:	00002097          	auipc	ra,0x2
    80003a6e:	774080e7          	jalr	1908(ra) # 800061de <release>
  }
}
    80003a72:	70e2                	ld	ra,56(sp)
    80003a74:	7442                	ld	s0,48(sp)
    80003a76:	74a2                	ld	s1,40(sp)
    80003a78:	7902                	ld	s2,32(sp)
    80003a7a:	69e2                	ld	s3,24(sp)
    80003a7c:	6a42                	ld	s4,16(sp)
    80003a7e:	6aa2                	ld	s5,8(sp)
    80003a80:	6121                	addi	sp,sp,64
    80003a82:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a84:	85d6                	mv	a1,s5
    80003a86:	8552                	mv	a0,s4
    80003a88:	00000097          	auipc	ra,0x0
    80003a8c:	34c080e7          	jalr	844(ra) # 80003dd4 <pipeclose>
    80003a90:	b7cd                	j	80003a72 <fileclose+0xa8>

0000000080003a92 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a92:	715d                	addi	sp,sp,-80
    80003a94:	e486                	sd	ra,72(sp)
    80003a96:	e0a2                	sd	s0,64(sp)
    80003a98:	fc26                	sd	s1,56(sp)
    80003a9a:	f84a                	sd	s2,48(sp)
    80003a9c:	f44e                	sd	s3,40(sp)
    80003a9e:	0880                	addi	s0,sp,80
    80003aa0:	84aa                	mv	s1,a0
    80003aa2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003aa4:	ffffd097          	auipc	ra,0xffffd
    80003aa8:	406080e7          	jalr	1030(ra) # 80000eaa <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003aac:	409c                	lw	a5,0(s1)
    80003aae:	37f9                	addiw	a5,a5,-2
    80003ab0:	4705                	li	a4,1
    80003ab2:	04f76763          	bltu	a4,a5,80003b00 <filestat+0x6e>
    80003ab6:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ab8:	6c88                	ld	a0,24(s1)
    80003aba:	fffff097          	auipc	ra,0xfffff
    80003abe:	082080e7          	jalr	130(ra) # 80002b3c <ilock>
    stati(f->ip, &st);
    80003ac2:	fb840593          	addi	a1,s0,-72
    80003ac6:	6c88                	ld	a0,24(s1)
    80003ac8:	fffff097          	auipc	ra,0xfffff
    80003acc:	2fe080e7          	jalr	766(ra) # 80002dc6 <stati>
    iunlock(f->ip);
    80003ad0:	6c88                	ld	a0,24(s1)
    80003ad2:	fffff097          	auipc	ra,0xfffff
    80003ad6:	12c080e7          	jalr	300(ra) # 80002bfe <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ada:	46e1                	li	a3,24
    80003adc:	fb840613          	addi	a2,s0,-72
    80003ae0:	85ce                	mv	a1,s3
    80003ae2:	05093503          	ld	a0,80(s2)
    80003ae6:	ffffd097          	auipc	ra,0xffffd
    80003aea:	04c080e7          	jalr	76(ra) # 80000b32 <copyout>
    80003aee:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003af2:	60a6                	ld	ra,72(sp)
    80003af4:	6406                	ld	s0,64(sp)
    80003af6:	74e2                	ld	s1,56(sp)
    80003af8:	7942                	ld	s2,48(sp)
    80003afa:	79a2                	ld	s3,40(sp)
    80003afc:	6161                	addi	sp,sp,80
    80003afe:	8082                	ret
  return -1;
    80003b00:	557d                	li	a0,-1
    80003b02:	bfc5                	j	80003af2 <filestat+0x60>

0000000080003b04 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b04:	7179                	addi	sp,sp,-48
    80003b06:	f406                	sd	ra,40(sp)
    80003b08:	f022                	sd	s0,32(sp)
    80003b0a:	ec26                	sd	s1,24(sp)
    80003b0c:	e84a                	sd	s2,16(sp)
    80003b0e:	e44e                	sd	s3,8(sp)
    80003b10:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b12:	00854783          	lbu	a5,8(a0)
    80003b16:	c3d5                	beqz	a5,80003bba <fileread+0xb6>
    80003b18:	84aa                	mv	s1,a0
    80003b1a:	89ae                	mv	s3,a1
    80003b1c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b1e:	411c                	lw	a5,0(a0)
    80003b20:	4705                	li	a4,1
    80003b22:	04e78963          	beq	a5,a4,80003b74 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b26:	470d                	li	a4,3
    80003b28:	04e78d63          	beq	a5,a4,80003b82 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b2c:	4709                	li	a4,2
    80003b2e:	06e79e63          	bne	a5,a4,80003baa <fileread+0xa6>
    ilock(f->ip);
    80003b32:	6d08                	ld	a0,24(a0)
    80003b34:	fffff097          	auipc	ra,0xfffff
    80003b38:	008080e7          	jalr	8(ra) # 80002b3c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b3c:	874a                	mv	a4,s2
    80003b3e:	5094                	lw	a3,32(s1)
    80003b40:	864e                	mv	a2,s3
    80003b42:	4585                	li	a1,1
    80003b44:	6c88                	ld	a0,24(s1)
    80003b46:	fffff097          	auipc	ra,0xfffff
    80003b4a:	2aa080e7          	jalr	682(ra) # 80002df0 <readi>
    80003b4e:	892a                	mv	s2,a0
    80003b50:	00a05563          	blez	a0,80003b5a <fileread+0x56>
      f->off += r;
    80003b54:	509c                	lw	a5,32(s1)
    80003b56:	9fa9                	addw	a5,a5,a0
    80003b58:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b5a:	6c88                	ld	a0,24(s1)
    80003b5c:	fffff097          	auipc	ra,0xfffff
    80003b60:	0a2080e7          	jalr	162(ra) # 80002bfe <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b64:	854a                	mv	a0,s2
    80003b66:	70a2                	ld	ra,40(sp)
    80003b68:	7402                	ld	s0,32(sp)
    80003b6a:	64e2                	ld	s1,24(sp)
    80003b6c:	6942                	ld	s2,16(sp)
    80003b6e:	69a2                	ld	s3,8(sp)
    80003b70:	6145                	addi	sp,sp,48
    80003b72:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b74:	6908                	ld	a0,16(a0)
    80003b76:	00000097          	auipc	ra,0x0
    80003b7a:	3c6080e7          	jalr	966(ra) # 80003f3c <piperead>
    80003b7e:	892a                	mv	s2,a0
    80003b80:	b7d5                	j	80003b64 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b82:	02451783          	lh	a5,36(a0)
    80003b86:	03079693          	slli	a3,a5,0x30
    80003b8a:	92c1                	srli	a3,a3,0x30
    80003b8c:	4725                	li	a4,9
    80003b8e:	02d76863          	bltu	a4,a3,80003bbe <fileread+0xba>
    80003b92:	0792                	slli	a5,a5,0x4
    80003b94:	00015717          	auipc	a4,0x15
    80003b98:	e0470713          	addi	a4,a4,-508 # 80018998 <devsw>
    80003b9c:	97ba                	add	a5,a5,a4
    80003b9e:	639c                	ld	a5,0(a5)
    80003ba0:	c38d                	beqz	a5,80003bc2 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ba2:	4505                	li	a0,1
    80003ba4:	9782                	jalr	a5
    80003ba6:	892a                	mv	s2,a0
    80003ba8:	bf75                	j	80003b64 <fileread+0x60>
    panic("fileread");
    80003baa:	00005517          	auipc	a0,0x5
    80003bae:	abe50513          	addi	a0,a0,-1346 # 80008668 <syscalls+0x258>
    80003bb2:	00002097          	auipc	ra,0x2
    80003bb6:	03c080e7          	jalr	60(ra) # 80005bee <panic>
    return -1;
    80003bba:	597d                	li	s2,-1
    80003bbc:	b765                	j	80003b64 <fileread+0x60>
      return -1;
    80003bbe:	597d                	li	s2,-1
    80003bc0:	b755                	j	80003b64 <fileread+0x60>
    80003bc2:	597d                	li	s2,-1
    80003bc4:	b745                	j	80003b64 <fileread+0x60>

0000000080003bc6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003bc6:	715d                	addi	sp,sp,-80
    80003bc8:	e486                	sd	ra,72(sp)
    80003bca:	e0a2                	sd	s0,64(sp)
    80003bcc:	fc26                	sd	s1,56(sp)
    80003bce:	f84a                	sd	s2,48(sp)
    80003bd0:	f44e                	sd	s3,40(sp)
    80003bd2:	f052                	sd	s4,32(sp)
    80003bd4:	ec56                	sd	s5,24(sp)
    80003bd6:	e85a                	sd	s6,16(sp)
    80003bd8:	e45e                	sd	s7,8(sp)
    80003bda:	e062                	sd	s8,0(sp)
    80003bdc:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003bde:	00954783          	lbu	a5,9(a0)
    80003be2:	10078663          	beqz	a5,80003cee <filewrite+0x128>
    80003be6:	892a                	mv	s2,a0
    80003be8:	8aae                	mv	s5,a1
    80003bea:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bec:	411c                	lw	a5,0(a0)
    80003bee:	4705                	li	a4,1
    80003bf0:	02e78263          	beq	a5,a4,80003c14 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bf4:	470d                	li	a4,3
    80003bf6:	02e78663          	beq	a5,a4,80003c22 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bfa:	4709                	li	a4,2
    80003bfc:	0ee79163          	bne	a5,a4,80003cde <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c00:	0ac05d63          	blez	a2,80003cba <filewrite+0xf4>
    int i = 0;
    80003c04:	4981                	li	s3,0
    80003c06:	6b05                	lui	s6,0x1
    80003c08:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c0c:	6b85                	lui	s7,0x1
    80003c0e:	c00b8b9b          	addiw	s7,s7,-1024
    80003c12:	a861                	j	80003caa <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c14:	6908                	ld	a0,16(a0)
    80003c16:	00000097          	auipc	ra,0x0
    80003c1a:	22e080e7          	jalr	558(ra) # 80003e44 <pipewrite>
    80003c1e:	8a2a                	mv	s4,a0
    80003c20:	a045                	j	80003cc0 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c22:	02451783          	lh	a5,36(a0)
    80003c26:	03079693          	slli	a3,a5,0x30
    80003c2a:	92c1                	srli	a3,a3,0x30
    80003c2c:	4725                	li	a4,9
    80003c2e:	0cd76263          	bltu	a4,a3,80003cf2 <filewrite+0x12c>
    80003c32:	0792                	slli	a5,a5,0x4
    80003c34:	00015717          	auipc	a4,0x15
    80003c38:	d6470713          	addi	a4,a4,-668 # 80018998 <devsw>
    80003c3c:	97ba                	add	a5,a5,a4
    80003c3e:	679c                	ld	a5,8(a5)
    80003c40:	cbdd                	beqz	a5,80003cf6 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c42:	4505                	li	a0,1
    80003c44:	9782                	jalr	a5
    80003c46:	8a2a                	mv	s4,a0
    80003c48:	a8a5                	j	80003cc0 <filewrite+0xfa>
    80003c4a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003c4e:	00000097          	auipc	ra,0x0
    80003c52:	8b0080e7          	jalr	-1872(ra) # 800034fe <begin_op>
      ilock(f->ip);
    80003c56:	01893503          	ld	a0,24(s2)
    80003c5a:	fffff097          	auipc	ra,0xfffff
    80003c5e:	ee2080e7          	jalr	-286(ra) # 80002b3c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c62:	8762                	mv	a4,s8
    80003c64:	02092683          	lw	a3,32(s2)
    80003c68:	01598633          	add	a2,s3,s5
    80003c6c:	4585                	li	a1,1
    80003c6e:	01893503          	ld	a0,24(s2)
    80003c72:	fffff097          	auipc	ra,0xfffff
    80003c76:	276080e7          	jalr	630(ra) # 80002ee8 <writei>
    80003c7a:	84aa                	mv	s1,a0
    80003c7c:	00a05763          	blez	a0,80003c8a <filewrite+0xc4>
        f->off += r;
    80003c80:	02092783          	lw	a5,32(s2)
    80003c84:	9fa9                	addw	a5,a5,a0
    80003c86:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c8a:	01893503          	ld	a0,24(s2)
    80003c8e:	fffff097          	auipc	ra,0xfffff
    80003c92:	f70080e7          	jalr	-144(ra) # 80002bfe <iunlock>
      end_op();
    80003c96:	00000097          	auipc	ra,0x0
    80003c9a:	8e8080e7          	jalr	-1816(ra) # 8000357e <end_op>

      if(r != n1){
    80003c9e:	009c1f63          	bne	s8,s1,80003cbc <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ca2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ca6:	0149db63          	bge	s3,s4,80003cbc <filewrite+0xf6>
      int n1 = n - i;
    80003caa:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003cae:	84be                	mv	s1,a5
    80003cb0:	2781                	sext.w	a5,a5
    80003cb2:	f8fb5ce3          	bge	s6,a5,80003c4a <filewrite+0x84>
    80003cb6:	84de                	mv	s1,s7
    80003cb8:	bf49                	j	80003c4a <filewrite+0x84>
    int i = 0;
    80003cba:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003cbc:	013a1f63          	bne	s4,s3,80003cda <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003cc0:	8552                	mv	a0,s4
    80003cc2:	60a6                	ld	ra,72(sp)
    80003cc4:	6406                	ld	s0,64(sp)
    80003cc6:	74e2                	ld	s1,56(sp)
    80003cc8:	7942                	ld	s2,48(sp)
    80003cca:	79a2                	ld	s3,40(sp)
    80003ccc:	7a02                	ld	s4,32(sp)
    80003cce:	6ae2                	ld	s5,24(sp)
    80003cd0:	6b42                	ld	s6,16(sp)
    80003cd2:	6ba2                	ld	s7,8(sp)
    80003cd4:	6c02                	ld	s8,0(sp)
    80003cd6:	6161                	addi	sp,sp,80
    80003cd8:	8082                	ret
    ret = (i == n ? n : -1);
    80003cda:	5a7d                	li	s4,-1
    80003cdc:	b7d5                	j	80003cc0 <filewrite+0xfa>
    panic("filewrite");
    80003cde:	00005517          	auipc	a0,0x5
    80003ce2:	99a50513          	addi	a0,a0,-1638 # 80008678 <syscalls+0x268>
    80003ce6:	00002097          	auipc	ra,0x2
    80003cea:	f08080e7          	jalr	-248(ra) # 80005bee <panic>
    return -1;
    80003cee:	5a7d                	li	s4,-1
    80003cf0:	bfc1                	j	80003cc0 <filewrite+0xfa>
      return -1;
    80003cf2:	5a7d                	li	s4,-1
    80003cf4:	b7f1                	j	80003cc0 <filewrite+0xfa>
    80003cf6:	5a7d                	li	s4,-1
    80003cf8:	b7e1                	j	80003cc0 <filewrite+0xfa>

0000000080003cfa <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cfa:	7179                	addi	sp,sp,-48
    80003cfc:	f406                	sd	ra,40(sp)
    80003cfe:	f022                	sd	s0,32(sp)
    80003d00:	ec26                	sd	s1,24(sp)
    80003d02:	e84a                	sd	s2,16(sp)
    80003d04:	e44e                	sd	s3,8(sp)
    80003d06:	e052                	sd	s4,0(sp)
    80003d08:	1800                	addi	s0,sp,48
    80003d0a:	84aa                	mv	s1,a0
    80003d0c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d0e:	0005b023          	sd	zero,0(a1)
    80003d12:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d16:	00000097          	auipc	ra,0x0
    80003d1a:	bf8080e7          	jalr	-1032(ra) # 8000390e <filealloc>
    80003d1e:	e088                	sd	a0,0(s1)
    80003d20:	c551                	beqz	a0,80003dac <pipealloc+0xb2>
    80003d22:	00000097          	auipc	ra,0x0
    80003d26:	bec080e7          	jalr	-1044(ra) # 8000390e <filealloc>
    80003d2a:	00aa3023          	sd	a0,0(s4)
    80003d2e:	c92d                	beqz	a0,80003da0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d30:	ffffc097          	auipc	ra,0xffffc
    80003d34:	3e8080e7          	jalr	1000(ra) # 80000118 <kalloc>
    80003d38:	892a                	mv	s2,a0
    80003d3a:	c125                	beqz	a0,80003d9a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d3c:	4985                	li	s3,1
    80003d3e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d42:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d46:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d4a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d4e:	00005597          	auipc	a1,0x5
    80003d52:	93a58593          	addi	a1,a1,-1734 # 80008688 <syscalls+0x278>
    80003d56:	00002097          	auipc	ra,0x2
    80003d5a:	344080e7          	jalr	836(ra) # 8000609a <initlock>
  (*f0)->type = FD_PIPE;
    80003d5e:	609c                	ld	a5,0(s1)
    80003d60:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d64:	609c                	ld	a5,0(s1)
    80003d66:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d6a:	609c                	ld	a5,0(s1)
    80003d6c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d70:	609c                	ld	a5,0(s1)
    80003d72:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d76:	000a3783          	ld	a5,0(s4)
    80003d7a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d7e:	000a3783          	ld	a5,0(s4)
    80003d82:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d86:	000a3783          	ld	a5,0(s4)
    80003d8a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d8e:	000a3783          	ld	a5,0(s4)
    80003d92:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d96:	4501                	li	a0,0
    80003d98:	a025                	j	80003dc0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d9a:	6088                	ld	a0,0(s1)
    80003d9c:	e501                	bnez	a0,80003da4 <pipealloc+0xaa>
    80003d9e:	a039                	j	80003dac <pipealloc+0xb2>
    80003da0:	6088                	ld	a0,0(s1)
    80003da2:	c51d                	beqz	a0,80003dd0 <pipealloc+0xd6>
    fileclose(*f0);
    80003da4:	00000097          	auipc	ra,0x0
    80003da8:	c26080e7          	jalr	-986(ra) # 800039ca <fileclose>
  if(*f1)
    80003dac:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003db0:	557d                	li	a0,-1
  if(*f1)
    80003db2:	c799                	beqz	a5,80003dc0 <pipealloc+0xc6>
    fileclose(*f1);
    80003db4:	853e                	mv	a0,a5
    80003db6:	00000097          	auipc	ra,0x0
    80003dba:	c14080e7          	jalr	-1004(ra) # 800039ca <fileclose>
  return -1;
    80003dbe:	557d                	li	a0,-1
}
    80003dc0:	70a2                	ld	ra,40(sp)
    80003dc2:	7402                	ld	s0,32(sp)
    80003dc4:	64e2                	ld	s1,24(sp)
    80003dc6:	6942                	ld	s2,16(sp)
    80003dc8:	69a2                	ld	s3,8(sp)
    80003dca:	6a02                	ld	s4,0(sp)
    80003dcc:	6145                	addi	sp,sp,48
    80003dce:	8082                	ret
  return -1;
    80003dd0:	557d                	li	a0,-1
    80003dd2:	b7fd                	j	80003dc0 <pipealloc+0xc6>

0000000080003dd4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dd4:	1101                	addi	sp,sp,-32
    80003dd6:	ec06                	sd	ra,24(sp)
    80003dd8:	e822                	sd	s0,16(sp)
    80003dda:	e426                	sd	s1,8(sp)
    80003ddc:	e04a                	sd	s2,0(sp)
    80003dde:	1000                	addi	s0,sp,32
    80003de0:	84aa                	mv	s1,a0
    80003de2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003de4:	00002097          	auipc	ra,0x2
    80003de8:	346080e7          	jalr	838(ra) # 8000612a <acquire>
  if(writable){
    80003dec:	02090d63          	beqz	s2,80003e26 <pipeclose+0x52>
    pi->writeopen = 0;
    80003df0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003df4:	21848513          	addi	a0,s1,536
    80003df8:	ffffd097          	auipc	ra,0xffffd
    80003dfc:	7c2080e7          	jalr	1986(ra) # 800015ba <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e00:	2204b783          	ld	a5,544(s1)
    80003e04:	eb95                	bnez	a5,80003e38 <pipeclose+0x64>
    release(&pi->lock);
    80003e06:	8526                	mv	a0,s1
    80003e08:	00002097          	auipc	ra,0x2
    80003e0c:	3d6080e7          	jalr	982(ra) # 800061de <release>
    kfree((char*)pi);
    80003e10:	8526                	mv	a0,s1
    80003e12:	ffffc097          	auipc	ra,0xffffc
    80003e16:	20a080e7          	jalr	522(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e1a:	60e2                	ld	ra,24(sp)
    80003e1c:	6442                	ld	s0,16(sp)
    80003e1e:	64a2                	ld	s1,8(sp)
    80003e20:	6902                	ld	s2,0(sp)
    80003e22:	6105                	addi	sp,sp,32
    80003e24:	8082                	ret
    pi->readopen = 0;
    80003e26:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e2a:	21c48513          	addi	a0,s1,540
    80003e2e:	ffffd097          	auipc	ra,0xffffd
    80003e32:	78c080e7          	jalr	1932(ra) # 800015ba <wakeup>
    80003e36:	b7e9                	j	80003e00 <pipeclose+0x2c>
    release(&pi->lock);
    80003e38:	8526                	mv	a0,s1
    80003e3a:	00002097          	auipc	ra,0x2
    80003e3e:	3a4080e7          	jalr	932(ra) # 800061de <release>
}
    80003e42:	bfe1                	j	80003e1a <pipeclose+0x46>

0000000080003e44 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e44:	711d                	addi	sp,sp,-96
    80003e46:	ec86                	sd	ra,88(sp)
    80003e48:	e8a2                	sd	s0,80(sp)
    80003e4a:	e4a6                	sd	s1,72(sp)
    80003e4c:	e0ca                	sd	s2,64(sp)
    80003e4e:	fc4e                	sd	s3,56(sp)
    80003e50:	f852                	sd	s4,48(sp)
    80003e52:	f456                	sd	s5,40(sp)
    80003e54:	f05a                	sd	s6,32(sp)
    80003e56:	ec5e                	sd	s7,24(sp)
    80003e58:	e862                	sd	s8,16(sp)
    80003e5a:	1080                	addi	s0,sp,96
    80003e5c:	84aa                	mv	s1,a0
    80003e5e:	8aae                	mv	s5,a1
    80003e60:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e62:	ffffd097          	auipc	ra,0xffffd
    80003e66:	048080e7          	jalr	72(ra) # 80000eaa <myproc>
    80003e6a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e6c:	8526                	mv	a0,s1
    80003e6e:	00002097          	auipc	ra,0x2
    80003e72:	2bc080e7          	jalr	700(ra) # 8000612a <acquire>
  while(i < n){
    80003e76:	0b405663          	blez	s4,80003f22 <pipewrite+0xde>
  int i = 0;
    80003e7a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e7c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e7e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e82:	21c48b93          	addi	s7,s1,540
    80003e86:	a089                	j	80003ec8 <pipewrite+0x84>
      release(&pi->lock);
    80003e88:	8526                	mv	a0,s1
    80003e8a:	00002097          	auipc	ra,0x2
    80003e8e:	354080e7          	jalr	852(ra) # 800061de <release>
      return -1;
    80003e92:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e94:	854a                	mv	a0,s2
    80003e96:	60e6                	ld	ra,88(sp)
    80003e98:	6446                	ld	s0,80(sp)
    80003e9a:	64a6                	ld	s1,72(sp)
    80003e9c:	6906                	ld	s2,64(sp)
    80003e9e:	79e2                	ld	s3,56(sp)
    80003ea0:	7a42                	ld	s4,48(sp)
    80003ea2:	7aa2                	ld	s5,40(sp)
    80003ea4:	7b02                	ld	s6,32(sp)
    80003ea6:	6be2                	ld	s7,24(sp)
    80003ea8:	6c42                	ld	s8,16(sp)
    80003eaa:	6125                	addi	sp,sp,96
    80003eac:	8082                	ret
      wakeup(&pi->nread);
    80003eae:	8562                	mv	a0,s8
    80003eb0:	ffffd097          	auipc	ra,0xffffd
    80003eb4:	70a080e7          	jalr	1802(ra) # 800015ba <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003eb8:	85a6                	mv	a1,s1
    80003eba:	855e                	mv	a0,s7
    80003ebc:	ffffd097          	auipc	ra,0xffffd
    80003ec0:	69a080e7          	jalr	1690(ra) # 80001556 <sleep>
  while(i < n){
    80003ec4:	07495063          	bge	s2,s4,80003f24 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003ec8:	2204a783          	lw	a5,544(s1)
    80003ecc:	dfd5                	beqz	a5,80003e88 <pipewrite+0x44>
    80003ece:	854e                	mv	a0,s3
    80003ed0:	ffffe097          	auipc	ra,0xffffe
    80003ed4:	92e080e7          	jalr	-1746(ra) # 800017fe <killed>
    80003ed8:	f945                	bnez	a0,80003e88 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003eda:	2184a783          	lw	a5,536(s1)
    80003ede:	21c4a703          	lw	a4,540(s1)
    80003ee2:	2007879b          	addiw	a5,a5,512
    80003ee6:	fcf704e3          	beq	a4,a5,80003eae <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003eea:	4685                	li	a3,1
    80003eec:	01590633          	add	a2,s2,s5
    80003ef0:	faf40593          	addi	a1,s0,-81
    80003ef4:	0509b503          	ld	a0,80(s3)
    80003ef8:	ffffd097          	auipc	ra,0xffffd
    80003efc:	cfa080e7          	jalr	-774(ra) # 80000bf2 <copyin>
    80003f00:	03650263          	beq	a0,s6,80003f24 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f04:	21c4a783          	lw	a5,540(s1)
    80003f08:	0017871b          	addiw	a4,a5,1
    80003f0c:	20e4ae23          	sw	a4,540(s1)
    80003f10:	1ff7f793          	andi	a5,a5,511
    80003f14:	97a6                	add	a5,a5,s1
    80003f16:	faf44703          	lbu	a4,-81(s0)
    80003f1a:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f1e:	2905                	addiw	s2,s2,1
    80003f20:	b755                	j	80003ec4 <pipewrite+0x80>
  int i = 0;
    80003f22:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f24:	21848513          	addi	a0,s1,536
    80003f28:	ffffd097          	auipc	ra,0xffffd
    80003f2c:	692080e7          	jalr	1682(ra) # 800015ba <wakeup>
  release(&pi->lock);
    80003f30:	8526                	mv	a0,s1
    80003f32:	00002097          	auipc	ra,0x2
    80003f36:	2ac080e7          	jalr	684(ra) # 800061de <release>
  return i;
    80003f3a:	bfa9                	j	80003e94 <pipewrite+0x50>

0000000080003f3c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f3c:	715d                	addi	sp,sp,-80
    80003f3e:	e486                	sd	ra,72(sp)
    80003f40:	e0a2                	sd	s0,64(sp)
    80003f42:	fc26                	sd	s1,56(sp)
    80003f44:	f84a                	sd	s2,48(sp)
    80003f46:	f44e                	sd	s3,40(sp)
    80003f48:	f052                	sd	s4,32(sp)
    80003f4a:	ec56                	sd	s5,24(sp)
    80003f4c:	e85a                	sd	s6,16(sp)
    80003f4e:	0880                	addi	s0,sp,80
    80003f50:	84aa                	mv	s1,a0
    80003f52:	892e                	mv	s2,a1
    80003f54:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f56:	ffffd097          	auipc	ra,0xffffd
    80003f5a:	f54080e7          	jalr	-172(ra) # 80000eaa <myproc>
    80003f5e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f60:	8526                	mv	a0,s1
    80003f62:	00002097          	auipc	ra,0x2
    80003f66:	1c8080e7          	jalr	456(ra) # 8000612a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f6a:	2184a703          	lw	a4,536(s1)
    80003f6e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f72:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f76:	02f71763          	bne	a4,a5,80003fa4 <piperead+0x68>
    80003f7a:	2244a783          	lw	a5,548(s1)
    80003f7e:	c39d                	beqz	a5,80003fa4 <piperead+0x68>
    if(killed(pr)){
    80003f80:	8552                	mv	a0,s4
    80003f82:	ffffe097          	auipc	ra,0xffffe
    80003f86:	87c080e7          	jalr	-1924(ra) # 800017fe <killed>
    80003f8a:	e941                	bnez	a0,8000401a <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f8c:	85a6                	mv	a1,s1
    80003f8e:	854e                	mv	a0,s3
    80003f90:	ffffd097          	auipc	ra,0xffffd
    80003f94:	5c6080e7          	jalr	1478(ra) # 80001556 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f98:	2184a703          	lw	a4,536(s1)
    80003f9c:	21c4a783          	lw	a5,540(s1)
    80003fa0:	fcf70de3          	beq	a4,a5,80003f7a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fa4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fa6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fa8:	05505363          	blez	s5,80003fee <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003fac:	2184a783          	lw	a5,536(s1)
    80003fb0:	21c4a703          	lw	a4,540(s1)
    80003fb4:	02f70d63          	beq	a4,a5,80003fee <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fb8:	0017871b          	addiw	a4,a5,1
    80003fbc:	20e4ac23          	sw	a4,536(s1)
    80003fc0:	1ff7f793          	andi	a5,a5,511
    80003fc4:	97a6                	add	a5,a5,s1
    80003fc6:	0187c783          	lbu	a5,24(a5)
    80003fca:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fce:	4685                	li	a3,1
    80003fd0:	fbf40613          	addi	a2,s0,-65
    80003fd4:	85ca                	mv	a1,s2
    80003fd6:	050a3503          	ld	a0,80(s4)
    80003fda:	ffffd097          	auipc	ra,0xffffd
    80003fde:	b58080e7          	jalr	-1192(ra) # 80000b32 <copyout>
    80003fe2:	01650663          	beq	a0,s6,80003fee <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fe6:	2985                	addiw	s3,s3,1
    80003fe8:	0905                	addi	s2,s2,1
    80003fea:	fd3a91e3          	bne	s5,s3,80003fac <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003fee:	21c48513          	addi	a0,s1,540
    80003ff2:	ffffd097          	auipc	ra,0xffffd
    80003ff6:	5c8080e7          	jalr	1480(ra) # 800015ba <wakeup>
  release(&pi->lock);
    80003ffa:	8526                	mv	a0,s1
    80003ffc:	00002097          	auipc	ra,0x2
    80004000:	1e2080e7          	jalr	482(ra) # 800061de <release>
  return i;
}
    80004004:	854e                	mv	a0,s3
    80004006:	60a6                	ld	ra,72(sp)
    80004008:	6406                	ld	s0,64(sp)
    8000400a:	74e2                	ld	s1,56(sp)
    8000400c:	7942                	ld	s2,48(sp)
    8000400e:	79a2                	ld	s3,40(sp)
    80004010:	7a02                	ld	s4,32(sp)
    80004012:	6ae2                	ld	s5,24(sp)
    80004014:	6b42                	ld	s6,16(sp)
    80004016:	6161                	addi	sp,sp,80
    80004018:	8082                	ret
      release(&pi->lock);
    8000401a:	8526                	mv	a0,s1
    8000401c:	00002097          	auipc	ra,0x2
    80004020:	1c2080e7          	jalr	450(ra) # 800061de <release>
      return -1;
    80004024:	59fd                	li	s3,-1
    80004026:	bff9                	j	80004004 <piperead+0xc8>

0000000080004028 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004028:	1141                	addi	sp,sp,-16
    8000402a:	e422                	sd	s0,8(sp)
    8000402c:	0800                	addi	s0,sp,16
    8000402e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004030:	8905                	andi	a0,a0,1
    80004032:	c111                	beqz	a0,80004036 <flags2perm+0xe>
      perm = PTE_X;
    80004034:	4521                	li	a0,8
    if(flags & 0x2)
    80004036:	8b89                	andi	a5,a5,2
    80004038:	c399                	beqz	a5,8000403e <flags2perm+0x16>
      perm |= PTE_W;
    8000403a:	00456513          	ori	a0,a0,4
    return perm;
}
    8000403e:	6422                	ld	s0,8(sp)
    80004040:	0141                	addi	sp,sp,16
    80004042:	8082                	ret

0000000080004044 <exec>:

int
exec(char *path, char **argv)
{
    80004044:	de010113          	addi	sp,sp,-544
    80004048:	20113c23          	sd	ra,536(sp)
    8000404c:	20813823          	sd	s0,528(sp)
    80004050:	20913423          	sd	s1,520(sp)
    80004054:	21213023          	sd	s2,512(sp)
    80004058:	ffce                	sd	s3,504(sp)
    8000405a:	fbd2                	sd	s4,496(sp)
    8000405c:	f7d6                	sd	s5,488(sp)
    8000405e:	f3da                	sd	s6,480(sp)
    80004060:	efde                	sd	s7,472(sp)
    80004062:	ebe2                	sd	s8,464(sp)
    80004064:	e7e6                	sd	s9,456(sp)
    80004066:	e3ea                	sd	s10,448(sp)
    80004068:	ff6e                	sd	s11,440(sp)
    8000406a:	1400                	addi	s0,sp,544
    8000406c:	892a                	mv	s2,a0
    8000406e:	dea43423          	sd	a0,-536(s0)
    80004072:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004076:	ffffd097          	auipc	ra,0xffffd
    8000407a:	e34080e7          	jalr	-460(ra) # 80000eaa <myproc>
    8000407e:	84aa                	mv	s1,a0

  begin_op();
    80004080:	fffff097          	auipc	ra,0xfffff
    80004084:	47e080e7          	jalr	1150(ra) # 800034fe <begin_op>

  if((ip = namei(path)) == 0){
    80004088:	854a                	mv	a0,s2
    8000408a:	fffff097          	auipc	ra,0xfffff
    8000408e:	258080e7          	jalr	600(ra) # 800032e2 <namei>
    80004092:	c93d                	beqz	a0,80004108 <exec+0xc4>
    80004094:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004096:	fffff097          	auipc	ra,0xfffff
    8000409a:	aa6080e7          	jalr	-1370(ra) # 80002b3c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000409e:	04000713          	li	a4,64
    800040a2:	4681                	li	a3,0
    800040a4:	e5040613          	addi	a2,s0,-432
    800040a8:	4581                	li	a1,0
    800040aa:	8556                	mv	a0,s5
    800040ac:	fffff097          	auipc	ra,0xfffff
    800040b0:	d44080e7          	jalr	-700(ra) # 80002df0 <readi>
    800040b4:	04000793          	li	a5,64
    800040b8:	00f51a63          	bne	a0,a5,800040cc <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800040bc:	e5042703          	lw	a4,-432(s0)
    800040c0:	464c47b7          	lui	a5,0x464c4
    800040c4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040c8:	04f70663          	beq	a4,a5,80004114 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040cc:	8556                	mv	a0,s5
    800040ce:	fffff097          	auipc	ra,0xfffff
    800040d2:	cd0080e7          	jalr	-816(ra) # 80002d9e <iunlockput>
    end_op();
    800040d6:	fffff097          	auipc	ra,0xfffff
    800040da:	4a8080e7          	jalr	1192(ra) # 8000357e <end_op>
  }
  return -1;
    800040de:	557d                	li	a0,-1
}
    800040e0:	21813083          	ld	ra,536(sp)
    800040e4:	21013403          	ld	s0,528(sp)
    800040e8:	20813483          	ld	s1,520(sp)
    800040ec:	20013903          	ld	s2,512(sp)
    800040f0:	79fe                	ld	s3,504(sp)
    800040f2:	7a5e                	ld	s4,496(sp)
    800040f4:	7abe                	ld	s5,488(sp)
    800040f6:	7b1e                	ld	s6,480(sp)
    800040f8:	6bfe                	ld	s7,472(sp)
    800040fa:	6c5e                	ld	s8,464(sp)
    800040fc:	6cbe                	ld	s9,456(sp)
    800040fe:	6d1e                	ld	s10,448(sp)
    80004100:	7dfa                	ld	s11,440(sp)
    80004102:	22010113          	addi	sp,sp,544
    80004106:	8082                	ret
    end_op();
    80004108:	fffff097          	auipc	ra,0xfffff
    8000410c:	476080e7          	jalr	1142(ra) # 8000357e <end_op>
    return -1;
    80004110:	557d                	li	a0,-1
    80004112:	b7f9                	j	800040e0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004114:	8526                	mv	a0,s1
    80004116:	ffffd097          	auipc	ra,0xffffd
    8000411a:	e5c080e7          	jalr	-420(ra) # 80000f72 <proc_pagetable>
    8000411e:	8b2a                	mv	s6,a0
    80004120:	d555                	beqz	a0,800040cc <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004122:	e7042783          	lw	a5,-400(s0)
    80004126:	e8845703          	lhu	a4,-376(s0)
    8000412a:	c735                	beqz	a4,80004196 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000412c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000412e:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004132:	6a05                	lui	s4,0x1
    80004134:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004138:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000413c:	6d85                	lui	s11,0x1
    8000413e:	7d7d                	lui	s10,0xfffff
    80004140:	a481                	j	80004380 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004142:	00004517          	auipc	a0,0x4
    80004146:	54e50513          	addi	a0,a0,1358 # 80008690 <syscalls+0x280>
    8000414a:	00002097          	auipc	ra,0x2
    8000414e:	aa4080e7          	jalr	-1372(ra) # 80005bee <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004152:	874a                	mv	a4,s2
    80004154:	009c86bb          	addw	a3,s9,s1
    80004158:	4581                	li	a1,0
    8000415a:	8556                	mv	a0,s5
    8000415c:	fffff097          	auipc	ra,0xfffff
    80004160:	c94080e7          	jalr	-876(ra) # 80002df0 <readi>
    80004164:	2501                	sext.w	a0,a0
    80004166:	1aa91a63          	bne	s2,a0,8000431a <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    8000416a:	009d84bb          	addw	s1,s11,s1
    8000416e:	013d09bb          	addw	s3,s10,s3
    80004172:	1f74f763          	bgeu	s1,s7,80004360 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    80004176:	02049593          	slli	a1,s1,0x20
    8000417a:	9181                	srli	a1,a1,0x20
    8000417c:	95e2                	add	a1,a1,s8
    8000417e:	855a                	mv	a0,s6
    80004180:	ffffc097          	auipc	ra,0xffffc
    80004184:	382080e7          	jalr	898(ra) # 80000502 <walkaddr>
    80004188:	862a                	mv	a2,a0
    if(pa == 0)
    8000418a:	dd45                	beqz	a0,80004142 <exec+0xfe>
      n = PGSIZE;
    8000418c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000418e:	fd49f2e3          	bgeu	s3,s4,80004152 <exec+0x10e>
      n = sz - i;
    80004192:	894e                	mv	s2,s3
    80004194:	bf7d                	j	80004152 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004196:	4901                	li	s2,0
  iunlockput(ip);
    80004198:	8556                	mv	a0,s5
    8000419a:	fffff097          	auipc	ra,0xfffff
    8000419e:	c04080e7          	jalr	-1020(ra) # 80002d9e <iunlockput>
  end_op();
    800041a2:	fffff097          	auipc	ra,0xfffff
    800041a6:	3dc080e7          	jalr	988(ra) # 8000357e <end_op>
  p = myproc();
    800041aa:	ffffd097          	auipc	ra,0xffffd
    800041ae:	d00080e7          	jalr	-768(ra) # 80000eaa <myproc>
    800041b2:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800041b4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041b8:	6785                	lui	a5,0x1
    800041ba:	17fd                	addi	a5,a5,-1
    800041bc:	993e                	add	s2,s2,a5
    800041be:	77fd                	lui	a5,0xfffff
    800041c0:	00f977b3          	and	a5,s2,a5
    800041c4:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041c8:	4691                	li	a3,4
    800041ca:	6609                	lui	a2,0x2
    800041cc:	963e                	add	a2,a2,a5
    800041ce:	85be                	mv	a1,a5
    800041d0:	855a                	mv	a0,s6
    800041d2:	ffffc097          	auipc	ra,0xffffc
    800041d6:	708080e7          	jalr	1800(ra) # 800008da <uvmalloc>
    800041da:	8c2a                	mv	s8,a0
  ip = 0;
    800041dc:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041de:	12050e63          	beqz	a0,8000431a <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041e2:	75f9                	lui	a1,0xffffe
    800041e4:	95aa                	add	a1,a1,a0
    800041e6:	855a                	mv	a0,s6
    800041e8:	ffffd097          	auipc	ra,0xffffd
    800041ec:	918080e7          	jalr	-1768(ra) # 80000b00 <uvmclear>
  stackbase = sp - PGSIZE;
    800041f0:	7afd                	lui	s5,0xfffff
    800041f2:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800041f4:	df043783          	ld	a5,-528(s0)
    800041f8:	6388                	ld	a0,0(a5)
    800041fa:	c925                	beqz	a0,8000426a <exec+0x226>
    800041fc:	e9040993          	addi	s3,s0,-368
    80004200:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004204:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004206:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004208:	ffffc097          	auipc	ra,0xffffc
    8000420c:	0ec080e7          	jalr	236(ra) # 800002f4 <strlen>
    80004210:	0015079b          	addiw	a5,a0,1
    80004214:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004218:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000421c:	13596663          	bltu	s2,s5,80004348 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004220:	df043d83          	ld	s11,-528(s0)
    80004224:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004228:	8552                	mv	a0,s4
    8000422a:	ffffc097          	auipc	ra,0xffffc
    8000422e:	0ca080e7          	jalr	202(ra) # 800002f4 <strlen>
    80004232:	0015069b          	addiw	a3,a0,1
    80004236:	8652                	mv	a2,s4
    80004238:	85ca                	mv	a1,s2
    8000423a:	855a                	mv	a0,s6
    8000423c:	ffffd097          	auipc	ra,0xffffd
    80004240:	8f6080e7          	jalr	-1802(ra) # 80000b32 <copyout>
    80004244:	10054663          	bltz	a0,80004350 <exec+0x30c>
    ustack[argc] = sp;
    80004248:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000424c:	0485                	addi	s1,s1,1
    8000424e:	008d8793          	addi	a5,s11,8
    80004252:	def43823          	sd	a5,-528(s0)
    80004256:	008db503          	ld	a0,8(s11)
    8000425a:	c911                	beqz	a0,8000426e <exec+0x22a>
    if(argc >= MAXARG)
    8000425c:	09a1                	addi	s3,s3,8
    8000425e:	fb3c95e3          	bne	s9,s3,80004208 <exec+0x1c4>
  sz = sz1;
    80004262:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004266:	4a81                	li	s5,0
    80004268:	a84d                	j	8000431a <exec+0x2d6>
  sp = sz;
    8000426a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000426c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000426e:	00349793          	slli	a5,s1,0x3
    80004272:	f9040713          	addi	a4,s0,-112
    80004276:	97ba                	add	a5,a5,a4
    80004278:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdd190>
  sp -= (argc+1) * sizeof(uint64);
    8000427c:	00148693          	addi	a3,s1,1
    80004280:	068e                	slli	a3,a3,0x3
    80004282:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004286:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000428a:	01597663          	bgeu	s2,s5,80004296 <exec+0x252>
  sz = sz1;
    8000428e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004292:	4a81                	li	s5,0
    80004294:	a059                	j	8000431a <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004296:	e9040613          	addi	a2,s0,-368
    8000429a:	85ca                	mv	a1,s2
    8000429c:	855a                	mv	a0,s6
    8000429e:	ffffd097          	auipc	ra,0xffffd
    800042a2:	894080e7          	jalr	-1900(ra) # 80000b32 <copyout>
    800042a6:	0a054963          	bltz	a0,80004358 <exec+0x314>
  p->trapframe->a1 = sp;
    800042aa:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800042ae:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042b2:	de843783          	ld	a5,-536(s0)
    800042b6:	0007c703          	lbu	a4,0(a5)
    800042ba:	cf11                	beqz	a4,800042d6 <exec+0x292>
    800042bc:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042be:	02f00693          	li	a3,47
    800042c2:	a039                	j	800042d0 <exec+0x28c>
      last = s+1;
    800042c4:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800042c8:	0785                	addi	a5,a5,1
    800042ca:	fff7c703          	lbu	a4,-1(a5)
    800042ce:	c701                	beqz	a4,800042d6 <exec+0x292>
    if(*s == '/')
    800042d0:	fed71ce3          	bne	a4,a3,800042c8 <exec+0x284>
    800042d4:	bfc5                	j	800042c4 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    800042d6:	4641                	li	a2,16
    800042d8:	de843583          	ld	a1,-536(s0)
    800042dc:	158b8513          	addi	a0,s7,344
    800042e0:	ffffc097          	auipc	ra,0xffffc
    800042e4:	fe2080e7          	jalr	-30(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    800042e8:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800042ec:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800042f0:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800042f4:	058bb783          	ld	a5,88(s7)
    800042f8:	e6843703          	ld	a4,-408(s0)
    800042fc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042fe:	058bb783          	ld	a5,88(s7)
    80004302:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004306:	85ea                	mv	a1,s10
    80004308:	ffffd097          	auipc	ra,0xffffd
    8000430c:	d06080e7          	jalr	-762(ra) # 8000100e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004310:	0004851b          	sext.w	a0,s1
    80004314:	b3f1                	j	800040e0 <exec+0x9c>
    80004316:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000431a:	df843583          	ld	a1,-520(s0)
    8000431e:	855a                	mv	a0,s6
    80004320:	ffffd097          	auipc	ra,0xffffd
    80004324:	cee080e7          	jalr	-786(ra) # 8000100e <proc_freepagetable>
  if(ip){
    80004328:	da0a92e3          	bnez	s5,800040cc <exec+0x88>
  return -1;
    8000432c:	557d                	li	a0,-1
    8000432e:	bb4d                	j	800040e0 <exec+0x9c>
    80004330:	df243c23          	sd	s2,-520(s0)
    80004334:	b7dd                	j	8000431a <exec+0x2d6>
    80004336:	df243c23          	sd	s2,-520(s0)
    8000433a:	b7c5                	j	8000431a <exec+0x2d6>
    8000433c:	df243c23          	sd	s2,-520(s0)
    80004340:	bfe9                	j	8000431a <exec+0x2d6>
    80004342:	df243c23          	sd	s2,-520(s0)
    80004346:	bfd1                	j	8000431a <exec+0x2d6>
  sz = sz1;
    80004348:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000434c:	4a81                	li	s5,0
    8000434e:	b7f1                	j	8000431a <exec+0x2d6>
  sz = sz1;
    80004350:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004354:	4a81                	li	s5,0
    80004356:	b7d1                	j	8000431a <exec+0x2d6>
  sz = sz1;
    80004358:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000435c:	4a81                	li	s5,0
    8000435e:	bf75                	j	8000431a <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004360:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004364:	e0843783          	ld	a5,-504(s0)
    80004368:	0017869b          	addiw	a3,a5,1
    8000436c:	e0d43423          	sd	a3,-504(s0)
    80004370:	e0043783          	ld	a5,-512(s0)
    80004374:	0387879b          	addiw	a5,a5,56
    80004378:	e8845703          	lhu	a4,-376(s0)
    8000437c:	e0e6dee3          	bge	a3,a4,80004198 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004380:	2781                	sext.w	a5,a5
    80004382:	e0f43023          	sd	a5,-512(s0)
    80004386:	03800713          	li	a4,56
    8000438a:	86be                	mv	a3,a5
    8000438c:	e1840613          	addi	a2,s0,-488
    80004390:	4581                	li	a1,0
    80004392:	8556                	mv	a0,s5
    80004394:	fffff097          	auipc	ra,0xfffff
    80004398:	a5c080e7          	jalr	-1444(ra) # 80002df0 <readi>
    8000439c:	03800793          	li	a5,56
    800043a0:	f6f51be3          	bne	a0,a5,80004316 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    800043a4:	e1842783          	lw	a5,-488(s0)
    800043a8:	4705                	li	a4,1
    800043aa:	fae79de3          	bne	a5,a4,80004364 <exec+0x320>
    if(ph.memsz < ph.filesz)
    800043ae:	e4043483          	ld	s1,-448(s0)
    800043b2:	e3843783          	ld	a5,-456(s0)
    800043b6:	f6f4ede3          	bltu	s1,a5,80004330 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043ba:	e2843783          	ld	a5,-472(s0)
    800043be:	94be                	add	s1,s1,a5
    800043c0:	f6f4ebe3          	bltu	s1,a5,80004336 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    800043c4:	de043703          	ld	a4,-544(s0)
    800043c8:	8ff9                	and	a5,a5,a4
    800043ca:	fbad                	bnez	a5,8000433c <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043cc:	e1c42503          	lw	a0,-484(s0)
    800043d0:	00000097          	auipc	ra,0x0
    800043d4:	c58080e7          	jalr	-936(ra) # 80004028 <flags2perm>
    800043d8:	86aa                	mv	a3,a0
    800043da:	8626                	mv	a2,s1
    800043dc:	85ca                	mv	a1,s2
    800043de:	855a                	mv	a0,s6
    800043e0:	ffffc097          	auipc	ra,0xffffc
    800043e4:	4fa080e7          	jalr	1274(ra) # 800008da <uvmalloc>
    800043e8:	dea43c23          	sd	a0,-520(s0)
    800043ec:	d939                	beqz	a0,80004342 <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043ee:	e2843c03          	ld	s8,-472(s0)
    800043f2:	e2042c83          	lw	s9,-480(s0)
    800043f6:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043fa:	f60b83e3          	beqz	s7,80004360 <exec+0x31c>
    800043fe:	89de                	mv	s3,s7
    80004400:	4481                	li	s1,0
    80004402:	bb95                	j	80004176 <exec+0x132>

0000000080004404 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004404:	7179                	addi	sp,sp,-48
    80004406:	f406                	sd	ra,40(sp)
    80004408:	f022                	sd	s0,32(sp)
    8000440a:	ec26                	sd	s1,24(sp)
    8000440c:	e84a                	sd	s2,16(sp)
    8000440e:	1800                	addi	s0,sp,48
    80004410:	892e                	mv	s2,a1
    80004412:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004414:	fdc40593          	addi	a1,s0,-36
    80004418:	ffffe097          	auipc	ra,0xffffe
    8000441c:	baa080e7          	jalr	-1110(ra) # 80001fc2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004420:	fdc42703          	lw	a4,-36(s0)
    80004424:	47bd                	li	a5,15
    80004426:	02e7eb63          	bltu	a5,a4,8000445c <argfd+0x58>
    8000442a:	ffffd097          	auipc	ra,0xffffd
    8000442e:	a80080e7          	jalr	-1408(ra) # 80000eaa <myproc>
    80004432:	fdc42703          	lw	a4,-36(s0)
    80004436:	01a70793          	addi	a5,a4,26
    8000443a:	078e                	slli	a5,a5,0x3
    8000443c:	953e                	add	a0,a0,a5
    8000443e:	611c                	ld	a5,0(a0)
    80004440:	c385                	beqz	a5,80004460 <argfd+0x5c>
    return -1;
  if(pfd)
    80004442:	00090463          	beqz	s2,8000444a <argfd+0x46>
    *pfd = fd;
    80004446:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000444a:	4501                	li	a0,0
  if(pf)
    8000444c:	c091                	beqz	s1,80004450 <argfd+0x4c>
    *pf = f;
    8000444e:	e09c                	sd	a5,0(s1)
}
    80004450:	70a2                	ld	ra,40(sp)
    80004452:	7402                	ld	s0,32(sp)
    80004454:	64e2                	ld	s1,24(sp)
    80004456:	6942                	ld	s2,16(sp)
    80004458:	6145                	addi	sp,sp,48
    8000445a:	8082                	ret
    return -1;
    8000445c:	557d                	li	a0,-1
    8000445e:	bfcd                	j	80004450 <argfd+0x4c>
    80004460:	557d                	li	a0,-1
    80004462:	b7fd                	j	80004450 <argfd+0x4c>

0000000080004464 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004464:	1101                	addi	sp,sp,-32
    80004466:	ec06                	sd	ra,24(sp)
    80004468:	e822                	sd	s0,16(sp)
    8000446a:	e426                	sd	s1,8(sp)
    8000446c:	1000                	addi	s0,sp,32
    8000446e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004470:	ffffd097          	auipc	ra,0xffffd
    80004474:	a3a080e7          	jalr	-1478(ra) # 80000eaa <myproc>
    80004478:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000447a:	0d050793          	addi	a5,a0,208
    8000447e:	4501                	li	a0,0
    80004480:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004482:	6398                	ld	a4,0(a5)
    80004484:	cb19                	beqz	a4,8000449a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004486:	2505                	addiw	a0,a0,1
    80004488:	07a1                	addi	a5,a5,8
    8000448a:	fed51ce3          	bne	a0,a3,80004482 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000448e:	557d                	li	a0,-1
}
    80004490:	60e2                	ld	ra,24(sp)
    80004492:	6442                	ld	s0,16(sp)
    80004494:	64a2                	ld	s1,8(sp)
    80004496:	6105                	addi	sp,sp,32
    80004498:	8082                	ret
      p->ofile[fd] = f;
    8000449a:	01a50793          	addi	a5,a0,26
    8000449e:	078e                	slli	a5,a5,0x3
    800044a0:	963e                	add	a2,a2,a5
    800044a2:	e204                	sd	s1,0(a2)
      return fd;
    800044a4:	b7f5                	j	80004490 <fdalloc+0x2c>

00000000800044a6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044a6:	715d                	addi	sp,sp,-80
    800044a8:	e486                	sd	ra,72(sp)
    800044aa:	e0a2                	sd	s0,64(sp)
    800044ac:	fc26                	sd	s1,56(sp)
    800044ae:	f84a                	sd	s2,48(sp)
    800044b0:	f44e                	sd	s3,40(sp)
    800044b2:	f052                	sd	s4,32(sp)
    800044b4:	ec56                	sd	s5,24(sp)
    800044b6:	e85a                	sd	s6,16(sp)
    800044b8:	0880                	addi	s0,sp,80
    800044ba:	8b2e                	mv	s6,a1
    800044bc:	89b2                	mv	s3,a2
    800044be:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044c0:	fb040593          	addi	a1,s0,-80
    800044c4:	fffff097          	auipc	ra,0xfffff
    800044c8:	e3c080e7          	jalr	-452(ra) # 80003300 <nameiparent>
    800044cc:	84aa                	mv	s1,a0
    800044ce:	14050f63          	beqz	a0,8000462c <create+0x186>
    return 0;

  ilock(dp);
    800044d2:	ffffe097          	auipc	ra,0xffffe
    800044d6:	66a080e7          	jalr	1642(ra) # 80002b3c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044da:	4601                	li	a2,0
    800044dc:	fb040593          	addi	a1,s0,-80
    800044e0:	8526                	mv	a0,s1
    800044e2:	fffff097          	auipc	ra,0xfffff
    800044e6:	b3e080e7          	jalr	-1218(ra) # 80003020 <dirlookup>
    800044ea:	8aaa                	mv	s5,a0
    800044ec:	c931                	beqz	a0,80004540 <create+0x9a>
    iunlockput(dp);
    800044ee:	8526                	mv	a0,s1
    800044f0:	fffff097          	auipc	ra,0xfffff
    800044f4:	8ae080e7          	jalr	-1874(ra) # 80002d9e <iunlockput>
    ilock(ip);
    800044f8:	8556                	mv	a0,s5
    800044fa:	ffffe097          	auipc	ra,0xffffe
    800044fe:	642080e7          	jalr	1602(ra) # 80002b3c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004502:	000b059b          	sext.w	a1,s6
    80004506:	4789                	li	a5,2
    80004508:	02f59563          	bne	a1,a5,80004532 <create+0x8c>
    8000450c:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd2d4>
    80004510:	37f9                	addiw	a5,a5,-2
    80004512:	17c2                	slli	a5,a5,0x30
    80004514:	93c1                	srli	a5,a5,0x30
    80004516:	4705                	li	a4,1
    80004518:	00f76d63          	bltu	a4,a5,80004532 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000451c:	8556                	mv	a0,s5
    8000451e:	60a6                	ld	ra,72(sp)
    80004520:	6406                	ld	s0,64(sp)
    80004522:	74e2                	ld	s1,56(sp)
    80004524:	7942                	ld	s2,48(sp)
    80004526:	79a2                	ld	s3,40(sp)
    80004528:	7a02                	ld	s4,32(sp)
    8000452a:	6ae2                	ld	s5,24(sp)
    8000452c:	6b42                	ld	s6,16(sp)
    8000452e:	6161                	addi	sp,sp,80
    80004530:	8082                	ret
    iunlockput(ip);
    80004532:	8556                	mv	a0,s5
    80004534:	fffff097          	auipc	ra,0xfffff
    80004538:	86a080e7          	jalr	-1942(ra) # 80002d9e <iunlockput>
    return 0;
    8000453c:	4a81                	li	s5,0
    8000453e:	bff9                	j	8000451c <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004540:	85da                	mv	a1,s6
    80004542:	4088                	lw	a0,0(s1)
    80004544:	ffffe097          	auipc	ra,0xffffe
    80004548:	45c080e7          	jalr	1116(ra) # 800029a0 <ialloc>
    8000454c:	8a2a                	mv	s4,a0
    8000454e:	c539                	beqz	a0,8000459c <create+0xf6>
  ilock(ip);
    80004550:	ffffe097          	auipc	ra,0xffffe
    80004554:	5ec080e7          	jalr	1516(ra) # 80002b3c <ilock>
  ip->major = major;
    80004558:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000455c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004560:	4905                	li	s2,1
    80004562:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004566:	8552                	mv	a0,s4
    80004568:	ffffe097          	auipc	ra,0xffffe
    8000456c:	50a080e7          	jalr	1290(ra) # 80002a72 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004570:	000b059b          	sext.w	a1,s6
    80004574:	03258b63          	beq	a1,s2,800045aa <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80004578:	004a2603          	lw	a2,4(s4)
    8000457c:	fb040593          	addi	a1,s0,-80
    80004580:	8526                	mv	a0,s1
    80004582:	fffff097          	auipc	ra,0xfffff
    80004586:	cae080e7          	jalr	-850(ra) # 80003230 <dirlink>
    8000458a:	06054f63          	bltz	a0,80004608 <create+0x162>
  iunlockput(dp);
    8000458e:	8526                	mv	a0,s1
    80004590:	fffff097          	auipc	ra,0xfffff
    80004594:	80e080e7          	jalr	-2034(ra) # 80002d9e <iunlockput>
  return ip;
    80004598:	8ad2                	mv	s5,s4
    8000459a:	b749                	j	8000451c <create+0x76>
    iunlockput(dp);
    8000459c:	8526                	mv	a0,s1
    8000459e:	fffff097          	auipc	ra,0xfffff
    800045a2:	800080e7          	jalr	-2048(ra) # 80002d9e <iunlockput>
    return 0;
    800045a6:	8ad2                	mv	s5,s4
    800045a8:	bf95                	j	8000451c <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045aa:	004a2603          	lw	a2,4(s4)
    800045ae:	00004597          	auipc	a1,0x4
    800045b2:	10258593          	addi	a1,a1,258 # 800086b0 <syscalls+0x2a0>
    800045b6:	8552                	mv	a0,s4
    800045b8:	fffff097          	auipc	ra,0xfffff
    800045bc:	c78080e7          	jalr	-904(ra) # 80003230 <dirlink>
    800045c0:	04054463          	bltz	a0,80004608 <create+0x162>
    800045c4:	40d0                	lw	a2,4(s1)
    800045c6:	00004597          	auipc	a1,0x4
    800045ca:	0f258593          	addi	a1,a1,242 # 800086b8 <syscalls+0x2a8>
    800045ce:	8552                	mv	a0,s4
    800045d0:	fffff097          	auipc	ra,0xfffff
    800045d4:	c60080e7          	jalr	-928(ra) # 80003230 <dirlink>
    800045d8:	02054863          	bltz	a0,80004608 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    800045dc:	004a2603          	lw	a2,4(s4)
    800045e0:	fb040593          	addi	a1,s0,-80
    800045e4:	8526                	mv	a0,s1
    800045e6:	fffff097          	auipc	ra,0xfffff
    800045ea:	c4a080e7          	jalr	-950(ra) # 80003230 <dirlink>
    800045ee:	00054d63          	bltz	a0,80004608 <create+0x162>
    dp->nlink++;  // for ".."
    800045f2:	04a4d783          	lhu	a5,74(s1)
    800045f6:	2785                	addiw	a5,a5,1
    800045f8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045fc:	8526                	mv	a0,s1
    800045fe:	ffffe097          	auipc	ra,0xffffe
    80004602:	474080e7          	jalr	1140(ra) # 80002a72 <iupdate>
    80004606:	b761                	j	8000458e <create+0xe8>
  ip->nlink = 0;
    80004608:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000460c:	8552                	mv	a0,s4
    8000460e:	ffffe097          	auipc	ra,0xffffe
    80004612:	464080e7          	jalr	1124(ra) # 80002a72 <iupdate>
  iunlockput(ip);
    80004616:	8552                	mv	a0,s4
    80004618:	ffffe097          	auipc	ra,0xffffe
    8000461c:	786080e7          	jalr	1926(ra) # 80002d9e <iunlockput>
  iunlockput(dp);
    80004620:	8526                	mv	a0,s1
    80004622:	ffffe097          	auipc	ra,0xffffe
    80004626:	77c080e7          	jalr	1916(ra) # 80002d9e <iunlockput>
  return 0;
    8000462a:	bdcd                	j	8000451c <create+0x76>
    return 0;
    8000462c:	8aaa                	mv	s5,a0
    8000462e:	b5fd                	j	8000451c <create+0x76>

0000000080004630 <sys_dup>:
{
    80004630:	7179                	addi	sp,sp,-48
    80004632:	f406                	sd	ra,40(sp)
    80004634:	f022                	sd	s0,32(sp)
    80004636:	ec26                	sd	s1,24(sp)
    80004638:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000463a:	fd840613          	addi	a2,s0,-40
    8000463e:	4581                	li	a1,0
    80004640:	4501                	li	a0,0
    80004642:	00000097          	auipc	ra,0x0
    80004646:	dc2080e7          	jalr	-574(ra) # 80004404 <argfd>
    return -1;
    8000464a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000464c:	02054363          	bltz	a0,80004672 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004650:	fd843503          	ld	a0,-40(s0)
    80004654:	00000097          	auipc	ra,0x0
    80004658:	e10080e7          	jalr	-496(ra) # 80004464 <fdalloc>
    8000465c:	84aa                	mv	s1,a0
    return -1;
    8000465e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004660:	00054963          	bltz	a0,80004672 <sys_dup+0x42>
  filedup(f);
    80004664:	fd843503          	ld	a0,-40(s0)
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	310080e7          	jalr	784(ra) # 80003978 <filedup>
  return fd;
    80004670:	87a6                	mv	a5,s1
}
    80004672:	853e                	mv	a0,a5
    80004674:	70a2                	ld	ra,40(sp)
    80004676:	7402                	ld	s0,32(sp)
    80004678:	64e2                	ld	s1,24(sp)
    8000467a:	6145                	addi	sp,sp,48
    8000467c:	8082                	ret

000000008000467e <sys_read>:
{
    8000467e:	7179                	addi	sp,sp,-48
    80004680:	f406                	sd	ra,40(sp)
    80004682:	f022                	sd	s0,32(sp)
    80004684:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004686:	fd840593          	addi	a1,s0,-40
    8000468a:	4505                	li	a0,1
    8000468c:	ffffe097          	auipc	ra,0xffffe
    80004690:	956080e7          	jalr	-1706(ra) # 80001fe2 <argaddr>
  argint(2, &n);
    80004694:	fe440593          	addi	a1,s0,-28
    80004698:	4509                	li	a0,2
    8000469a:	ffffe097          	auipc	ra,0xffffe
    8000469e:	928080e7          	jalr	-1752(ra) # 80001fc2 <argint>
  if(argfd(0, 0, &f) < 0)
    800046a2:	fe840613          	addi	a2,s0,-24
    800046a6:	4581                	li	a1,0
    800046a8:	4501                	li	a0,0
    800046aa:	00000097          	auipc	ra,0x0
    800046ae:	d5a080e7          	jalr	-678(ra) # 80004404 <argfd>
    800046b2:	87aa                	mv	a5,a0
    return -1;
    800046b4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046b6:	0007cc63          	bltz	a5,800046ce <sys_read+0x50>
  return fileread(f, p, n);
    800046ba:	fe442603          	lw	a2,-28(s0)
    800046be:	fd843583          	ld	a1,-40(s0)
    800046c2:	fe843503          	ld	a0,-24(s0)
    800046c6:	fffff097          	auipc	ra,0xfffff
    800046ca:	43e080e7          	jalr	1086(ra) # 80003b04 <fileread>
}
    800046ce:	70a2                	ld	ra,40(sp)
    800046d0:	7402                	ld	s0,32(sp)
    800046d2:	6145                	addi	sp,sp,48
    800046d4:	8082                	ret

00000000800046d6 <sys_write>:
{
    800046d6:	7179                	addi	sp,sp,-48
    800046d8:	f406                	sd	ra,40(sp)
    800046da:	f022                	sd	s0,32(sp)
    800046dc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046de:	fd840593          	addi	a1,s0,-40
    800046e2:	4505                	li	a0,1
    800046e4:	ffffe097          	auipc	ra,0xffffe
    800046e8:	8fe080e7          	jalr	-1794(ra) # 80001fe2 <argaddr>
  argint(2, &n);
    800046ec:	fe440593          	addi	a1,s0,-28
    800046f0:	4509                	li	a0,2
    800046f2:	ffffe097          	auipc	ra,0xffffe
    800046f6:	8d0080e7          	jalr	-1840(ra) # 80001fc2 <argint>
  if(argfd(0, 0, &f) < 0)
    800046fa:	fe840613          	addi	a2,s0,-24
    800046fe:	4581                	li	a1,0
    80004700:	4501                	li	a0,0
    80004702:	00000097          	auipc	ra,0x0
    80004706:	d02080e7          	jalr	-766(ra) # 80004404 <argfd>
    8000470a:	87aa                	mv	a5,a0
    return -1;
    8000470c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000470e:	0007cc63          	bltz	a5,80004726 <sys_write+0x50>
  return filewrite(f, p, n);
    80004712:	fe442603          	lw	a2,-28(s0)
    80004716:	fd843583          	ld	a1,-40(s0)
    8000471a:	fe843503          	ld	a0,-24(s0)
    8000471e:	fffff097          	auipc	ra,0xfffff
    80004722:	4a8080e7          	jalr	1192(ra) # 80003bc6 <filewrite>
}
    80004726:	70a2                	ld	ra,40(sp)
    80004728:	7402                	ld	s0,32(sp)
    8000472a:	6145                	addi	sp,sp,48
    8000472c:	8082                	ret

000000008000472e <sys_close>:
{
    8000472e:	1101                	addi	sp,sp,-32
    80004730:	ec06                	sd	ra,24(sp)
    80004732:	e822                	sd	s0,16(sp)
    80004734:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004736:	fe040613          	addi	a2,s0,-32
    8000473a:	fec40593          	addi	a1,s0,-20
    8000473e:	4501                	li	a0,0
    80004740:	00000097          	auipc	ra,0x0
    80004744:	cc4080e7          	jalr	-828(ra) # 80004404 <argfd>
    return -1;
    80004748:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000474a:	02054463          	bltz	a0,80004772 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000474e:	ffffc097          	auipc	ra,0xffffc
    80004752:	75c080e7          	jalr	1884(ra) # 80000eaa <myproc>
    80004756:	fec42783          	lw	a5,-20(s0)
    8000475a:	07e9                	addi	a5,a5,26
    8000475c:	078e                	slli	a5,a5,0x3
    8000475e:	97aa                	add	a5,a5,a0
    80004760:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004764:	fe043503          	ld	a0,-32(s0)
    80004768:	fffff097          	auipc	ra,0xfffff
    8000476c:	262080e7          	jalr	610(ra) # 800039ca <fileclose>
  return 0;
    80004770:	4781                	li	a5,0
}
    80004772:	853e                	mv	a0,a5
    80004774:	60e2                	ld	ra,24(sp)
    80004776:	6442                	ld	s0,16(sp)
    80004778:	6105                	addi	sp,sp,32
    8000477a:	8082                	ret

000000008000477c <sys_fstat>:
{
    8000477c:	1101                	addi	sp,sp,-32
    8000477e:	ec06                	sd	ra,24(sp)
    80004780:	e822                	sd	s0,16(sp)
    80004782:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004784:	fe040593          	addi	a1,s0,-32
    80004788:	4505                	li	a0,1
    8000478a:	ffffe097          	auipc	ra,0xffffe
    8000478e:	858080e7          	jalr	-1960(ra) # 80001fe2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004792:	fe840613          	addi	a2,s0,-24
    80004796:	4581                	li	a1,0
    80004798:	4501                	li	a0,0
    8000479a:	00000097          	auipc	ra,0x0
    8000479e:	c6a080e7          	jalr	-918(ra) # 80004404 <argfd>
    800047a2:	87aa                	mv	a5,a0
    return -1;
    800047a4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047a6:	0007ca63          	bltz	a5,800047ba <sys_fstat+0x3e>
  return filestat(f, st);
    800047aa:	fe043583          	ld	a1,-32(s0)
    800047ae:	fe843503          	ld	a0,-24(s0)
    800047b2:	fffff097          	auipc	ra,0xfffff
    800047b6:	2e0080e7          	jalr	736(ra) # 80003a92 <filestat>
}
    800047ba:	60e2                	ld	ra,24(sp)
    800047bc:	6442                	ld	s0,16(sp)
    800047be:	6105                	addi	sp,sp,32
    800047c0:	8082                	ret

00000000800047c2 <sys_link>:
{
    800047c2:	7169                	addi	sp,sp,-304
    800047c4:	f606                	sd	ra,296(sp)
    800047c6:	f222                	sd	s0,288(sp)
    800047c8:	ee26                	sd	s1,280(sp)
    800047ca:	ea4a                	sd	s2,272(sp)
    800047cc:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047ce:	08000613          	li	a2,128
    800047d2:	ed040593          	addi	a1,s0,-304
    800047d6:	4501                	li	a0,0
    800047d8:	ffffe097          	auipc	ra,0xffffe
    800047dc:	82a080e7          	jalr	-2006(ra) # 80002002 <argstr>
    return -1;
    800047e0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047e2:	10054e63          	bltz	a0,800048fe <sys_link+0x13c>
    800047e6:	08000613          	li	a2,128
    800047ea:	f5040593          	addi	a1,s0,-176
    800047ee:	4505                	li	a0,1
    800047f0:	ffffe097          	auipc	ra,0xffffe
    800047f4:	812080e7          	jalr	-2030(ra) # 80002002 <argstr>
    return -1;
    800047f8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047fa:	10054263          	bltz	a0,800048fe <sys_link+0x13c>
  begin_op();
    800047fe:	fffff097          	auipc	ra,0xfffff
    80004802:	d00080e7          	jalr	-768(ra) # 800034fe <begin_op>
  if((ip = namei(old)) == 0){
    80004806:	ed040513          	addi	a0,s0,-304
    8000480a:	fffff097          	auipc	ra,0xfffff
    8000480e:	ad8080e7          	jalr	-1320(ra) # 800032e2 <namei>
    80004812:	84aa                	mv	s1,a0
    80004814:	c551                	beqz	a0,800048a0 <sys_link+0xde>
  ilock(ip);
    80004816:	ffffe097          	auipc	ra,0xffffe
    8000481a:	326080e7          	jalr	806(ra) # 80002b3c <ilock>
  if(ip->type == T_DIR){
    8000481e:	04449703          	lh	a4,68(s1)
    80004822:	4785                	li	a5,1
    80004824:	08f70463          	beq	a4,a5,800048ac <sys_link+0xea>
  ip->nlink++;
    80004828:	04a4d783          	lhu	a5,74(s1)
    8000482c:	2785                	addiw	a5,a5,1
    8000482e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004832:	8526                	mv	a0,s1
    80004834:	ffffe097          	auipc	ra,0xffffe
    80004838:	23e080e7          	jalr	574(ra) # 80002a72 <iupdate>
  iunlock(ip);
    8000483c:	8526                	mv	a0,s1
    8000483e:	ffffe097          	auipc	ra,0xffffe
    80004842:	3c0080e7          	jalr	960(ra) # 80002bfe <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004846:	fd040593          	addi	a1,s0,-48
    8000484a:	f5040513          	addi	a0,s0,-176
    8000484e:	fffff097          	auipc	ra,0xfffff
    80004852:	ab2080e7          	jalr	-1358(ra) # 80003300 <nameiparent>
    80004856:	892a                	mv	s2,a0
    80004858:	c935                	beqz	a0,800048cc <sys_link+0x10a>
  ilock(dp);
    8000485a:	ffffe097          	auipc	ra,0xffffe
    8000485e:	2e2080e7          	jalr	738(ra) # 80002b3c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004862:	00092703          	lw	a4,0(s2)
    80004866:	409c                	lw	a5,0(s1)
    80004868:	04f71d63          	bne	a4,a5,800048c2 <sys_link+0x100>
    8000486c:	40d0                	lw	a2,4(s1)
    8000486e:	fd040593          	addi	a1,s0,-48
    80004872:	854a                	mv	a0,s2
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	9bc080e7          	jalr	-1604(ra) # 80003230 <dirlink>
    8000487c:	04054363          	bltz	a0,800048c2 <sys_link+0x100>
  iunlockput(dp);
    80004880:	854a                	mv	a0,s2
    80004882:	ffffe097          	auipc	ra,0xffffe
    80004886:	51c080e7          	jalr	1308(ra) # 80002d9e <iunlockput>
  iput(ip);
    8000488a:	8526                	mv	a0,s1
    8000488c:	ffffe097          	auipc	ra,0xffffe
    80004890:	46a080e7          	jalr	1130(ra) # 80002cf6 <iput>
  end_op();
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	cea080e7          	jalr	-790(ra) # 8000357e <end_op>
  return 0;
    8000489c:	4781                	li	a5,0
    8000489e:	a085                	j	800048fe <sys_link+0x13c>
    end_op();
    800048a0:	fffff097          	auipc	ra,0xfffff
    800048a4:	cde080e7          	jalr	-802(ra) # 8000357e <end_op>
    return -1;
    800048a8:	57fd                	li	a5,-1
    800048aa:	a891                	j	800048fe <sys_link+0x13c>
    iunlockput(ip);
    800048ac:	8526                	mv	a0,s1
    800048ae:	ffffe097          	auipc	ra,0xffffe
    800048b2:	4f0080e7          	jalr	1264(ra) # 80002d9e <iunlockput>
    end_op();
    800048b6:	fffff097          	auipc	ra,0xfffff
    800048ba:	cc8080e7          	jalr	-824(ra) # 8000357e <end_op>
    return -1;
    800048be:	57fd                	li	a5,-1
    800048c0:	a83d                	j	800048fe <sys_link+0x13c>
    iunlockput(dp);
    800048c2:	854a                	mv	a0,s2
    800048c4:	ffffe097          	auipc	ra,0xffffe
    800048c8:	4da080e7          	jalr	1242(ra) # 80002d9e <iunlockput>
  ilock(ip);
    800048cc:	8526                	mv	a0,s1
    800048ce:	ffffe097          	auipc	ra,0xffffe
    800048d2:	26e080e7          	jalr	622(ra) # 80002b3c <ilock>
  ip->nlink--;
    800048d6:	04a4d783          	lhu	a5,74(s1)
    800048da:	37fd                	addiw	a5,a5,-1
    800048dc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048e0:	8526                	mv	a0,s1
    800048e2:	ffffe097          	auipc	ra,0xffffe
    800048e6:	190080e7          	jalr	400(ra) # 80002a72 <iupdate>
  iunlockput(ip);
    800048ea:	8526                	mv	a0,s1
    800048ec:	ffffe097          	auipc	ra,0xffffe
    800048f0:	4b2080e7          	jalr	1202(ra) # 80002d9e <iunlockput>
  end_op();
    800048f4:	fffff097          	auipc	ra,0xfffff
    800048f8:	c8a080e7          	jalr	-886(ra) # 8000357e <end_op>
  return -1;
    800048fc:	57fd                	li	a5,-1
}
    800048fe:	853e                	mv	a0,a5
    80004900:	70b2                	ld	ra,296(sp)
    80004902:	7412                	ld	s0,288(sp)
    80004904:	64f2                	ld	s1,280(sp)
    80004906:	6952                	ld	s2,272(sp)
    80004908:	6155                	addi	sp,sp,304
    8000490a:	8082                	ret

000000008000490c <sys_unlink>:
{
    8000490c:	7151                	addi	sp,sp,-240
    8000490e:	f586                	sd	ra,232(sp)
    80004910:	f1a2                	sd	s0,224(sp)
    80004912:	eda6                	sd	s1,216(sp)
    80004914:	e9ca                	sd	s2,208(sp)
    80004916:	e5ce                	sd	s3,200(sp)
    80004918:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000491a:	08000613          	li	a2,128
    8000491e:	f3040593          	addi	a1,s0,-208
    80004922:	4501                	li	a0,0
    80004924:	ffffd097          	auipc	ra,0xffffd
    80004928:	6de080e7          	jalr	1758(ra) # 80002002 <argstr>
    8000492c:	18054163          	bltz	a0,80004aae <sys_unlink+0x1a2>
  begin_op();
    80004930:	fffff097          	auipc	ra,0xfffff
    80004934:	bce080e7          	jalr	-1074(ra) # 800034fe <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004938:	fb040593          	addi	a1,s0,-80
    8000493c:	f3040513          	addi	a0,s0,-208
    80004940:	fffff097          	auipc	ra,0xfffff
    80004944:	9c0080e7          	jalr	-1600(ra) # 80003300 <nameiparent>
    80004948:	84aa                	mv	s1,a0
    8000494a:	c979                	beqz	a0,80004a20 <sys_unlink+0x114>
  ilock(dp);
    8000494c:	ffffe097          	auipc	ra,0xffffe
    80004950:	1f0080e7          	jalr	496(ra) # 80002b3c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004954:	00004597          	auipc	a1,0x4
    80004958:	d5c58593          	addi	a1,a1,-676 # 800086b0 <syscalls+0x2a0>
    8000495c:	fb040513          	addi	a0,s0,-80
    80004960:	ffffe097          	auipc	ra,0xffffe
    80004964:	6a6080e7          	jalr	1702(ra) # 80003006 <namecmp>
    80004968:	14050a63          	beqz	a0,80004abc <sys_unlink+0x1b0>
    8000496c:	00004597          	auipc	a1,0x4
    80004970:	d4c58593          	addi	a1,a1,-692 # 800086b8 <syscalls+0x2a8>
    80004974:	fb040513          	addi	a0,s0,-80
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	68e080e7          	jalr	1678(ra) # 80003006 <namecmp>
    80004980:	12050e63          	beqz	a0,80004abc <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004984:	f2c40613          	addi	a2,s0,-212
    80004988:	fb040593          	addi	a1,s0,-80
    8000498c:	8526                	mv	a0,s1
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	692080e7          	jalr	1682(ra) # 80003020 <dirlookup>
    80004996:	892a                	mv	s2,a0
    80004998:	12050263          	beqz	a0,80004abc <sys_unlink+0x1b0>
  ilock(ip);
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	1a0080e7          	jalr	416(ra) # 80002b3c <ilock>
  if(ip->nlink < 1)
    800049a4:	04a91783          	lh	a5,74(s2)
    800049a8:	08f05263          	blez	a5,80004a2c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049ac:	04491703          	lh	a4,68(s2)
    800049b0:	4785                	li	a5,1
    800049b2:	08f70563          	beq	a4,a5,80004a3c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049b6:	4641                	li	a2,16
    800049b8:	4581                	li	a1,0
    800049ba:	fc040513          	addi	a0,s0,-64
    800049be:	ffffb097          	auipc	ra,0xffffb
    800049c2:	7ba080e7          	jalr	1978(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049c6:	4741                	li	a4,16
    800049c8:	f2c42683          	lw	a3,-212(s0)
    800049cc:	fc040613          	addi	a2,s0,-64
    800049d0:	4581                	li	a1,0
    800049d2:	8526                	mv	a0,s1
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	514080e7          	jalr	1300(ra) # 80002ee8 <writei>
    800049dc:	47c1                	li	a5,16
    800049de:	0af51563          	bne	a0,a5,80004a88 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049e2:	04491703          	lh	a4,68(s2)
    800049e6:	4785                	li	a5,1
    800049e8:	0af70863          	beq	a4,a5,80004a98 <sys_unlink+0x18c>
  iunlockput(dp);
    800049ec:	8526                	mv	a0,s1
    800049ee:	ffffe097          	auipc	ra,0xffffe
    800049f2:	3b0080e7          	jalr	944(ra) # 80002d9e <iunlockput>
  ip->nlink--;
    800049f6:	04a95783          	lhu	a5,74(s2)
    800049fa:	37fd                	addiw	a5,a5,-1
    800049fc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a00:	854a                	mv	a0,s2
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	070080e7          	jalr	112(ra) # 80002a72 <iupdate>
  iunlockput(ip);
    80004a0a:	854a                	mv	a0,s2
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	392080e7          	jalr	914(ra) # 80002d9e <iunlockput>
  end_op();
    80004a14:	fffff097          	auipc	ra,0xfffff
    80004a18:	b6a080e7          	jalr	-1174(ra) # 8000357e <end_op>
  return 0;
    80004a1c:	4501                	li	a0,0
    80004a1e:	a84d                	j	80004ad0 <sys_unlink+0x1c4>
    end_op();
    80004a20:	fffff097          	auipc	ra,0xfffff
    80004a24:	b5e080e7          	jalr	-1186(ra) # 8000357e <end_op>
    return -1;
    80004a28:	557d                	li	a0,-1
    80004a2a:	a05d                	j	80004ad0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a2c:	00004517          	auipc	a0,0x4
    80004a30:	c9450513          	addi	a0,a0,-876 # 800086c0 <syscalls+0x2b0>
    80004a34:	00001097          	auipc	ra,0x1
    80004a38:	1ba080e7          	jalr	442(ra) # 80005bee <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a3c:	04c92703          	lw	a4,76(s2)
    80004a40:	02000793          	li	a5,32
    80004a44:	f6e7f9e3          	bgeu	a5,a4,800049b6 <sys_unlink+0xaa>
    80004a48:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a4c:	4741                	li	a4,16
    80004a4e:	86ce                	mv	a3,s3
    80004a50:	f1840613          	addi	a2,s0,-232
    80004a54:	4581                	li	a1,0
    80004a56:	854a                	mv	a0,s2
    80004a58:	ffffe097          	auipc	ra,0xffffe
    80004a5c:	398080e7          	jalr	920(ra) # 80002df0 <readi>
    80004a60:	47c1                	li	a5,16
    80004a62:	00f51b63          	bne	a0,a5,80004a78 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a66:	f1845783          	lhu	a5,-232(s0)
    80004a6a:	e7a1                	bnez	a5,80004ab2 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a6c:	29c1                	addiw	s3,s3,16
    80004a6e:	04c92783          	lw	a5,76(s2)
    80004a72:	fcf9ede3          	bltu	s3,a5,80004a4c <sys_unlink+0x140>
    80004a76:	b781                	j	800049b6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a78:	00004517          	auipc	a0,0x4
    80004a7c:	c6050513          	addi	a0,a0,-928 # 800086d8 <syscalls+0x2c8>
    80004a80:	00001097          	auipc	ra,0x1
    80004a84:	16e080e7          	jalr	366(ra) # 80005bee <panic>
    panic("unlink: writei");
    80004a88:	00004517          	auipc	a0,0x4
    80004a8c:	c6850513          	addi	a0,a0,-920 # 800086f0 <syscalls+0x2e0>
    80004a90:	00001097          	auipc	ra,0x1
    80004a94:	15e080e7          	jalr	350(ra) # 80005bee <panic>
    dp->nlink--;
    80004a98:	04a4d783          	lhu	a5,74(s1)
    80004a9c:	37fd                	addiw	a5,a5,-1
    80004a9e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004aa2:	8526                	mv	a0,s1
    80004aa4:	ffffe097          	auipc	ra,0xffffe
    80004aa8:	fce080e7          	jalr	-50(ra) # 80002a72 <iupdate>
    80004aac:	b781                	j	800049ec <sys_unlink+0xe0>
    return -1;
    80004aae:	557d                	li	a0,-1
    80004ab0:	a005                	j	80004ad0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ab2:	854a                	mv	a0,s2
    80004ab4:	ffffe097          	auipc	ra,0xffffe
    80004ab8:	2ea080e7          	jalr	746(ra) # 80002d9e <iunlockput>
  iunlockput(dp);
    80004abc:	8526                	mv	a0,s1
    80004abe:	ffffe097          	auipc	ra,0xffffe
    80004ac2:	2e0080e7          	jalr	736(ra) # 80002d9e <iunlockput>
  end_op();
    80004ac6:	fffff097          	auipc	ra,0xfffff
    80004aca:	ab8080e7          	jalr	-1352(ra) # 8000357e <end_op>
  return -1;
    80004ace:	557d                	li	a0,-1
}
    80004ad0:	70ae                	ld	ra,232(sp)
    80004ad2:	740e                	ld	s0,224(sp)
    80004ad4:	64ee                	ld	s1,216(sp)
    80004ad6:	694e                	ld	s2,208(sp)
    80004ad8:	69ae                	ld	s3,200(sp)
    80004ada:	616d                	addi	sp,sp,240
    80004adc:	8082                	ret

0000000080004ade <sys_open>:

uint64
sys_open(void)
{
    80004ade:	7131                	addi	sp,sp,-192
    80004ae0:	fd06                	sd	ra,184(sp)
    80004ae2:	f922                	sd	s0,176(sp)
    80004ae4:	f526                	sd	s1,168(sp)
    80004ae6:	f14a                	sd	s2,160(sp)
    80004ae8:	ed4e                	sd	s3,152(sp)
    80004aea:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004aec:	f4c40593          	addi	a1,s0,-180
    80004af0:	4505                	li	a0,1
    80004af2:	ffffd097          	auipc	ra,0xffffd
    80004af6:	4d0080e7          	jalr	1232(ra) # 80001fc2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004afa:	08000613          	li	a2,128
    80004afe:	f5040593          	addi	a1,s0,-176
    80004b02:	4501                	li	a0,0
    80004b04:	ffffd097          	auipc	ra,0xffffd
    80004b08:	4fe080e7          	jalr	1278(ra) # 80002002 <argstr>
    80004b0c:	87aa                	mv	a5,a0
    return -1;
    80004b0e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b10:	0a07c963          	bltz	a5,80004bc2 <sys_open+0xe4>

  begin_op();
    80004b14:	fffff097          	auipc	ra,0xfffff
    80004b18:	9ea080e7          	jalr	-1558(ra) # 800034fe <begin_op>

  if(omode & O_CREATE){
    80004b1c:	f4c42783          	lw	a5,-180(s0)
    80004b20:	2007f793          	andi	a5,a5,512
    80004b24:	cfc5                	beqz	a5,80004bdc <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b26:	4681                	li	a3,0
    80004b28:	4601                	li	a2,0
    80004b2a:	4589                	li	a1,2
    80004b2c:	f5040513          	addi	a0,s0,-176
    80004b30:	00000097          	auipc	ra,0x0
    80004b34:	976080e7          	jalr	-1674(ra) # 800044a6 <create>
    80004b38:	84aa                	mv	s1,a0
    if(ip == 0){
    80004b3a:	c959                	beqz	a0,80004bd0 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b3c:	04449703          	lh	a4,68(s1)
    80004b40:	478d                	li	a5,3
    80004b42:	00f71763          	bne	a4,a5,80004b50 <sys_open+0x72>
    80004b46:	0464d703          	lhu	a4,70(s1)
    80004b4a:	47a5                	li	a5,9
    80004b4c:	0ce7ed63          	bltu	a5,a4,80004c26 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b50:	fffff097          	auipc	ra,0xfffff
    80004b54:	dbe080e7          	jalr	-578(ra) # 8000390e <filealloc>
    80004b58:	89aa                	mv	s3,a0
    80004b5a:	10050363          	beqz	a0,80004c60 <sys_open+0x182>
    80004b5e:	00000097          	auipc	ra,0x0
    80004b62:	906080e7          	jalr	-1786(ra) # 80004464 <fdalloc>
    80004b66:	892a                	mv	s2,a0
    80004b68:	0e054763          	bltz	a0,80004c56 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b6c:	04449703          	lh	a4,68(s1)
    80004b70:	478d                	li	a5,3
    80004b72:	0cf70563          	beq	a4,a5,80004c3c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b76:	4789                	li	a5,2
    80004b78:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b7c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b80:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b84:	f4c42783          	lw	a5,-180(s0)
    80004b88:	0017c713          	xori	a4,a5,1
    80004b8c:	8b05                	andi	a4,a4,1
    80004b8e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b92:	0037f713          	andi	a4,a5,3
    80004b96:	00e03733          	snez	a4,a4
    80004b9a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b9e:	4007f793          	andi	a5,a5,1024
    80004ba2:	c791                	beqz	a5,80004bae <sys_open+0xd0>
    80004ba4:	04449703          	lh	a4,68(s1)
    80004ba8:	4789                	li	a5,2
    80004baa:	0af70063          	beq	a4,a5,80004c4a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bae:	8526                	mv	a0,s1
    80004bb0:	ffffe097          	auipc	ra,0xffffe
    80004bb4:	04e080e7          	jalr	78(ra) # 80002bfe <iunlock>
  end_op();
    80004bb8:	fffff097          	auipc	ra,0xfffff
    80004bbc:	9c6080e7          	jalr	-1594(ra) # 8000357e <end_op>

  return fd;
    80004bc0:	854a                	mv	a0,s2
}
    80004bc2:	70ea                	ld	ra,184(sp)
    80004bc4:	744a                	ld	s0,176(sp)
    80004bc6:	74aa                	ld	s1,168(sp)
    80004bc8:	790a                	ld	s2,160(sp)
    80004bca:	69ea                	ld	s3,152(sp)
    80004bcc:	6129                	addi	sp,sp,192
    80004bce:	8082                	ret
      end_op();
    80004bd0:	fffff097          	auipc	ra,0xfffff
    80004bd4:	9ae080e7          	jalr	-1618(ra) # 8000357e <end_op>
      return -1;
    80004bd8:	557d                	li	a0,-1
    80004bda:	b7e5                	j	80004bc2 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004bdc:	f5040513          	addi	a0,s0,-176
    80004be0:	ffffe097          	auipc	ra,0xffffe
    80004be4:	702080e7          	jalr	1794(ra) # 800032e2 <namei>
    80004be8:	84aa                	mv	s1,a0
    80004bea:	c905                	beqz	a0,80004c1a <sys_open+0x13c>
    ilock(ip);
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	f50080e7          	jalr	-176(ra) # 80002b3c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004bf4:	04449703          	lh	a4,68(s1)
    80004bf8:	4785                	li	a5,1
    80004bfa:	f4f711e3          	bne	a4,a5,80004b3c <sys_open+0x5e>
    80004bfe:	f4c42783          	lw	a5,-180(s0)
    80004c02:	d7b9                	beqz	a5,80004b50 <sys_open+0x72>
      iunlockput(ip);
    80004c04:	8526                	mv	a0,s1
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	198080e7          	jalr	408(ra) # 80002d9e <iunlockput>
      end_op();
    80004c0e:	fffff097          	auipc	ra,0xfffff
    80004c12:	970080e7          	jalr	-1680(ra) # 8000357e <end_op>
      return -1;
    80004c16:	557d                	li	a0,-1
    80004c18:	b76d                	j	80004bc2 <sys_open+0xe4>
      end_op();
    80004c1a:	fffff097          	auipc	ra,0xfffff
    80004c1e:	964080e7          	jalr	-1692(ra) # 8000357e <end_op>
      return -1;
    80004c22:	557d                	li	a0,-1
    80004c24:	bf79                	j	80004bc2 <sys_open+0xe4>
    iunlockput(ip);
    80004c26:	8526                	mv	a0,s1
    80004c28:	ffffe097          	auipc	ra,0xffffe
    80004c2c:	176080e7          	jalr	374(ra) # 80002d9e <iunlockput>
    end_op();
    80004c30:	fffff097          	auipc	ra,0xfffff
    80004c34:	94e080e7          	jalr	-1714(ra) # 8000357e <end_op>
    return -1;
    80004c38:	557d                	li	a0,-1
    80004c3a:	b761                	j	80004bc2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c3c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c40:	04649783          	lh	a5,70(s1)
    80004c44:	02f99223          	sh	a5,36(s3)
    80004c48:	bf25                	j	80004b80 <sys_open+0xa2>
    itrunc(ip);
    80004c4a:	8526                	mv	a0,s1
    80004c4c:	ffffe097          	auipc	ra,0xffffe
    80004c50:	ffe080e7          	jalr	-2(ra) # 80002c4a <itrunc>
    80004c54:	bfa9                	j	80004bae <sys_open+0xd0>
      fileclose(f);
    80004c56:	854e                	mv	a0,s3
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	d72080e7          	jalr	-654(ra) # 800039ca <fileclose>
    iunlockput(ip);
    80004c60:	8526                	mv	a0,s1
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	13c080e7          	jalr	316(ra) # 80002d9e <iunlockput>
    end_op();
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	914080e7          	jalr	-1772(ra) # 8000357e <end_op>
    return -1;
    80004c72:	557d                	li	a0,-1
    80004c74:	b7b9                	j	80004bc2 <sys_open+0xe4>

0000000080004c76 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c76:	7175                	addi	sp,sp,-144
    80004c78:	e506                	sd	ra,136(sp)
    80004c7a:	e122                	sd	s0,128(sp)
    80004c7c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	880080e7          	jalr	-1920(ra) # 800034fe <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c86:	08000613          	li	a2,128
    80004c8a:	f7040593          	addi	a1,s0,-144
    80004c8e:	4501                	li	a0,0
    80004c90:	ffffd097          	auipc	ra,0xffffd
    80004c94:	372080e7          	jalr	882(ra) # 80002002 <argstr>
    80004c98:	02054963          	bltz	a0,80004cca <sys_mkdir+0x54>
    80004c9c:	4681                	li	a3,0
    80004c9e:	4601                	li	a2,0
    80004ca0:	4585                	li	a1,1
    80004ca2:	f7040513          	addi	a0,s0,-144
    80004ca6:	00000097          	auipc	ra,0x0
    80004caa:	800080e7          	jalr	-2048(ra) # 800044a6 <create>
    80004cae:	cd11                	beqz	a0,80004cca <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cb0:	ffffe097          	auipc	ra,0xffffe
    80004cb4:	0ee080e7          	jalr	238(ra) # 80002d9e <iunlockput>
  end_op();
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	8c6080e7          	jalr	-1850(ra) # 8000357e <end_op>
  return 0;
    80004cc0:	4501                	li	a0,0
}
    80004cc2:	60aa                	ld	ra,136(sp)
    80004cc4:	640a                	ld	s0,128(sp)
    80004cc6:	6149                	addi	sp,sp,144
    80004cc8:	8082                	ret
    end_op();
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	8b4080e7          	jalr	-1868(ra) # 8000357e <end_op>
    return -1;
    80004cd2:	557d                	li	a0,-1
    80004cd4:	b7fd                	j	80004cc2 <sys_mkdir+0x4c>

0000000080004cd6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cd6:	7135                	addi	sp,sp,-160
    80004cd8:	ed06                	sd	ra,152(sp)
    80004cda:	e922                	sd	s0,144(sp)
    80004cdc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	820080e7          	jalr	-2016(ra) # 800034fe <begin_op>
  argint(1, &major);
    80004ce6:	f6c40593          	addi	a1,s0,-148
    80004cea:	4505                	li	a0,1
    80004cec:	ffffd097          	auipc	ra,0xffffd
    80004cf0:	2d6080e7          	jalr	726(ra) # 80001fc2 <argint>
  argint(2, &minor);
    80004cf4:	f6840593          	addi	a1,s0,-152
    80004cf8:	4509                	li	a0,2
    80004cfa:	ffffd097          	auipc	ra,0xffffd
    80004cfe:	2c8080e7          	jalr	712(ra) # 80001fc2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d02:	08000613          	li	a2,128
    80004d06:	f7040593          	addi	a1,s0,-144
    80004d0a:	4501                	li	a0,0
    80004d0c:	ffffd097          	auipc	ra,0xffffd
    80004d10:	2f6080e7          	jalr	758(ra) # 80002002 <argstr>
    80004d14:	02054b63          	bltz	a0,80004d4a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d18:	f6841683          	lh	a3,-152(s0)
    80004d1c:	f6c41603          	lh	a2,-148(s0)
    80004d20:	458d                	li	a1,3
    80004d22:	f7040513          	addi	a0,s0,-144
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	780080e7          	jalr	1920(ra) # 800044a6 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d2e:	cd11                	beqz	a0,80004d4a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	06e080e7          	jalr	110(ra) # 80002d9e <iunlockput>
  end_op();
    80004d38:	fffff097          	auipc	ra,0xfffff
    80004d3c:	846080e7          	jalr	-1978(ra) # 8000357e <end_op>
  return 0;
    80004d40:	4501                	li	a0,0
}
    80004d42:	60ea                	ld	ra,152(sp)
    80004d44:	644a                	ld	s0,144(sp)
    80004d46:	610d                	addi	sp,sp,160
    80004d48:	8082                	ret
    end_op();
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	834080e7          	jalr	-1996(ra) # 8000357e <end_op>
    return -1;
    80004d52:	557d                	li	a0,-1
    80004d54:	b7fd                	j	80004d42 <sys_mknod+0x6c>

0000000080004d56 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d56:	7135                	addi	sp,sp,-160
    80004d58:	ed06                	sd	ra,152(sp)
    80004d5a:	e922                	sd	s0,144(sp)
    80004d5c:	e526                	sd	s1,136(sp)
    80004d5e:	e14a                	sd	s2,128(sp)
    80004d60:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d62:	ffffc097          	auipc	ra,0xffffc
    80004d66:	148080e7          	jalr	328(ra) # 80000eaa <myproc>
    80004d6a:	892a                	mv	s2,a0
  
  begin_op();
    80004d6c:	ffffe097          	auipc	ra,0xffffe
    80004d70:	792080e7          	jalr	1938(ra) # 800034fe <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d74:	08000613          	li	a2,128
    80004d78:	f6040593          	addi	a1,s0,-160
    80004d7c:	4501                	li	a0,0
    80004d7e:	ffffd097          	auipc	ra,0xffffd
    80004d82:	284080e7          	jalr	644(ra) # 80002002 <argstr>
    80004d86:	04054b63          	bltz	a0,80004ddc <sys_chdir+0x86>
    80004d8a:	f6040513          	addi	a0,s0,-160
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	554080e7          	jalr	1364(ra) # 800032e2 <namei>
    80004d96:	84aa                	mv	s1,a0
    80004d98:	c131                	beqz	a0,80004ddc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d9a:	ffffe097          	auipc	ra,0xffffe
    80004d9e:	da2080e7          	jalr	-606(ra) # 80002b3c <ilock>
  if(ip->type != T_DIR){
    80004da2:	04449703          	lh	a4,68(s1)
    80004da6:	4785                	li	a5,1
    80004da8:	04f71063          	bne	a4,a5,80004de8 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dac:	8526                	mv	a0,s1
    80004dae:	ffffe097          	auipc	ra,0xffffe
    80004db2:	e50080e7          	jalr	-432(ra) # 80002bfe <iunlock>
  iput(p->cwd);
    80004db6:	15093503          	ld	a0,336(s2)
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	f3c080e7          	jalr	-196(ra) # 80002cf6 <iput>
  end_op();
    80004dc2:	ffffe097          	auipc	ra,0xffffe
    80004dc6:	7bc080e7          	jalr	1980(ra) # 8000357e <end_op>
  p->cwd = ip;
    80004dca:	14993823          	sd	s1,336(s2)
  return 0;
    80004dce:	4501                	li	a0,0
}
    80004dd0:	60ea                	ld	ra,152(sp)
    80004dd2:	644a                	ld	s0,144(sp)
    80004dd4:	64aa                	ld	s1,136(sp)
    80004dd6:	690a                	ld	s2,128(sp)
    80004dd8:	610d                	addi	sp,sp,160
    80004dda:	8082                	ret
    end_op();
    80004ddc:	ffffe097          	auipc	ra,0xffffe
    80004de0:	7a2080e7          	jalr	1954(ra) # 8000357e <end_op>
    return -1;
    80004de4:	557d                	li	a0,-1
    80004de6:	b7ed                	j	80004dd0 <sys_chdir+0x7a>
    iunlockput(ip);
    80004de8:	8526                	mv	a0,s1
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	fb4080e7          	jalr	-76(ra) # 80002d9e <iunlockput>
    end_op();
    80004df2:	ffffe097          	auipc	ra,0xffffe
    80004df6:	78c080e7          	jalr	1932(ra) # 8000357e <end_op>
    return -1;
    80004dfa:	557d                	li	a0,-1
    80004dfc:	bfd1                	j	80004dd0 <sys_chdir+0x7a>

0000000080004dfe <sys_exec>:

uint64
sys_exec(void)
{
    80004dfe:	7145                	addi	sp,sp,-464
    80004e00:	e786                	sd	ra,456(sp)
    80004e02:	e3a2                	sd	s0,448(sp)
    80004e04:	ff26                	sd	s1,440(sp)
    80004e06:	fb4a                	sd	s2,432(sp)
    80004e08:	f74e                	sd	s3,424(sp)
    80004e0a:	f352                	sd	s4,416(sp)
    80004e0c:	ef56                	sd	s5,408(sp)
    80004e0e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e10:	e3840593          	addi	a1,s0,-456
    80004e14:	4505                	li	a0,1
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	1cc080e7          	jalr	460(ra) # 80001fe2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e1e:	08000613          	li	a2,128
    80004e22:	f4040593          	addi	a1,s0,-192
    80004e26:	4501                	li	a0,0
    80004e28:	ffffd097          	auipc	ra,0xffffd
    80004e2c:	1da080e7          	jalr	474(ra) # 80002002 <argstr>
    80004e30:	87aa                	mv	a5,a0
    return -1;
    80004e32:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004e34:	0c07c263          	bltz	a5,80004ef8 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e38:	10000613          	li	a2,256
    80004e3c:	4581                	li	a1,0
    80004e3e:	e4040513          	addi	a0,s0,-448
    80004e42:	ffffb097          	auipc	ra,0xffffb
    80004e46:	336080e7          	jalr	822(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e4a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e4e:	89a6                	mv	s3,s1
    80004e50:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e52:	02000a13          	li	s4,32
    80004e56:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e5a:	00391793          	slli	a5,s2,0x3
    80004e5e:	e3040593          	addi	a1,s0,-464
    80004e62:	e3843503          	ld	a0,-456(s0)
    80004e66:	953e                	add	a0,a0,a5
    80004e68:	ffffd097          	auipc	ra,0xffffd
    80004e6c:	0bc080e7          	jalr	188(ra) # 80001f24 <fetchaddr>
    80004e70:	02054a63          	bltz	a0,80004ea4 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004e74:	e3043783          	ld	a5,-464(s0)
    80004e78:	c3b9                	beqz	a5,80004ebe <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e7a:	ffffb097          	auipc	ra,0xffffb
    80004e7e:	29e080e7          	jalr	670(ra) # 80000118 <kalloc>
    80004e82:	85aa                	mv	a1,a0
    80004e84:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e88:	cd11                	beqz	a0,80004ea4 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e8a:	6605                	lui	a2,0x1
    80004e8c:	e3043503          	ld	a0,-464(s0)
    80004e90:	ffffd097          	auipc	ra,0xffffd
    80004e94:	0e6080e7          	jalr	230(ra) # 80001f76 <fetchstr>
    80004e98:	00054663          	bltz	a0,80004ea4 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004e9c:	0905                	addi	s2,s2,1
    80004e9e:	09a1                	addi	s3,s3,8
    80004ea0:	fb491be3          	bne	s2,s4,80004e56 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ea4:	10048913          	addi	s2,s1,256
    80004ea8:	6088                	ld	a0,0(s1)
    80004eaa:	c531                	beqz	a0,80004ef6 <sys_exec+0xf8>
    kfree(argv[i]);
    80004eac:	ffffb097          	auipc	ra,0xffffb
    80004eb0:	170080e7          	jalr	368(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eb4:	04a1                	addi	s1,s1,8
    80004eb6:	ff2499e3          	bne	s1,s2,80004ea8 <sys_exec+0xaa>
  return -1;
    80004eba:	557d                	li	a0,-1
    80004ebc:	a835                	j	80004ef8 <sys_exec+0xfa>
      argv[i] = 0;
    80004ebe:	0a8e                	slli	s5,s5,0x3
    80004ec0:	fc040793          	addi	a5,s0,-64
    80004ec4:	9abe                	add	s5,s5,a5
    80004ec6:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004eca:	e4040593          	addi	a1,s0,-448
    80004ece:	f4040513          	addi	a0,s0,-192
    80004ed2:	fffff097          	auipc	ra,0xfffff
    80004ed6:	172080e7          	jalr	370(ra) # 80004044 <exec>
    80004eda:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004edc:	10048993          	addi	s3,s1,256
    80004ee0:	6088                	ld	a0,0(s1)
    80004ee2:	c901                	beqz	a0,80004ef2 <sys_exec+0xf4>
    kfree(argv[i]);
    80004ee4:	ffffb097          	auipc	ra,0xffffb
    80004ee8:	138080e7          	jalr	312(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eec:	04a1                	addi	s1,s1,8
    80004eee:	ff3499e3          	bne	s1,s3,80004ee0 <sys_exec+0xe2>
  return ret;
    80004ef2:	854a                	mv	a0,s2
    80004ef4:	a011                	j	80004ef8 <sys_exec+0xfa>
  return -1;
    80004ef6:	557d                	li	a0,-1
}
    80004ef8:	60be                	ld	ra,456(sp)
    80004efa:	641e                	ld	s0,448(sp)
    80004efc:	74fa                	ld	s1,440(sp)
    80004efe:	795a                	ld	s2,432(sp)
    80004f00:	79ba                	ld	s3,424(sp)
    80004f02:	7a1a                	ld	s4,416(sp)
    80004f04:	6afa                	ld	s5,408(sp)
    80004f06:	6179                	addi	sp,sp,464
    80004f08:	8082                	ret

0000000080004f0a <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f0a:	7139                	addi	sp,sp,-64
    80004f0c:	fc06                	sd	ra,56(sp)
    80004f0e:	f822                	sd	s0,48(sp)
    80004f10:	f426                	sd	s1,40(sp)
    80004f12:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f14:	ffffc097          	auipc	ra,0xffffc
    80004f18:	f96080e7          	jalr	-106(ra) # 80000eaa <myproc>
    80004f1c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f1e:	fd840593          	addi	a1,s0,-40
    80004f22:	4501                	li	a0,0
    80004f24:	ffffd097          	auipc	ra,0xffffd
    80004f28:	0be080e7          	jalr	190(ra) # 80001fe2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f2c:	fc840593          	addi	a1,s0,-56
    80004f30:	fd040513          	addi	a0,s0,-48
    80004f34:	fffff097          	auipc	ra,0xfffff
    80004f38:	dc6080e7          	jalr	-570(ra) # 80003cfa <pipealloc>
    return -1;
    80004f3c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f3e:	0c054463          	bltz	a0,80005006 <sys_pipe+0xfc>
  fd0 = -1;
    80004f42:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f46:	fd043503          	ld	a0,-48(s0)
    80004f4a:	fffff097          	auipc	ra,0xfffff
    80004f4e:	51a080e7          	jalr	1306(ra) # 80004464 <fdalloc>
    80004f52:	fca42223          	sw	a0,-60(s0)
    80004f56:	08054b63          	bltz	a0,80004fec <sys_pipe+0xe2>
    80004f5a:	fc843503          	ld	a0,-56(s0)
    80004f5e:	fffff097          	auipc	ra,0xfffff
    80004f62:	506080e7          	jalr	1286(ra) # 80004464 <fdalloc>
    80004f66:	fca42023          	sw	a0,-64(s0)
    80004f6a:	06054863          	bltz	a0,80004fda <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f6e:	4691                	li	a3,4
    80004f70:	fc440613          	addi	a2,s0,-60
    80004f74:	fd843583          	ld	a1,-40(s0)
    80004f78:	68a8                	ld	a0,80(s1)
    80004f7a:	ffffc097          	auipc	ra,0xffffc
    80004f7e:	bb8080e7          	jalr	-1096(ra) # 80000b32 <copyout>
    80004f82:	02054063          	bltz	a0,80004fa2 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f86:	4691                	li	a3,4
    80004f88:	fc040613          	addi	a2,s0,-64
    80004f8c:	fd843583          	ld	a1,-40(s0)
    80004f90:	0591                	addi	a1,a1,4
    80004f92:	68a8                	ld	a0,80(s1)
    80004f94:	ffffc097          	auipc	ra,0xffffc
    80004f98:	b9e080e7          	jalr	-1122(ra) # 80000b32 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f9c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f9e:	06055463          	bgez	a0,80005006 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004fa2:	fc442783          	lw	a5,-60(s0)
    80004fa6:	07e9                	addi	a5,a5,26
    80004fa8:	078e                	slli	a5,a5,0x3
    80004faa:	97a6                	add	a5,a5,s1
    80004fac:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fb0:	fc042503          	lw	a0,-64(s0)
    80004fb4:	0569                	addi	a0,a0,26
    80004fb6:	050e                	slli	a0,a0,0x3
    80004fb8:	94aa                	add	s1,s1,a0
    80004fba:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004fbe:	fd043503          	ld	a0,-48(s0)
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	a08080e7          	jalr	-1528(ra) # 800039ca <fileclose>
    fileclose(wf);
    80004fca:	fc843503          	ld	a0,-56(s0)
    80004fce:	fffff097          	auipc	ra,0xfffff
    80004fd2:	9fc080e7          	jalr	-1540(ra) # 800039ca <fileclose>
    return -1;
    80004fd6:	57fd                	li	a5,-1
    80004fd8:	a03d                	j	80005006 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004fda:	fc442783          	lw	a5,-60(s0)
    80004fde:	0007c763          	bltz	a5,80004fec <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004fe2:	07e9                	addi	a5,a5,26
    80004fe4:	078e                	slli	a5,a5,0x3
    80004fe6:	94be                	add	s1,s1,a5
    80004fe8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004fec:	fd043503          	ld	a0,-48(s0)
    80004ff0:	fffff097          	auipc	ra,0xfffff
    80004ff4:	9da080e7          	jalr	-1574(ra) # 800039ca <fileclose>
    fileclose(wf);
    80004ff8:	fc843503          	ld	a0,-56(s0)
    80004ffc:	fffff097          	auipc	ra,0xfffff
    80005000:	9ce080e7          	jalr	-1586(ra) # 800039ca <fileclose>
    return -1;
    80005004:	57fd                	li	a5,-1
}
    80005006:	853e                	mv	a0,a5
    80005008:	70e2                	ld	ra,56(sp)
    8000500a:	7442                	ld	s0,48(sp)
    8000500c:	74a2                	ld	s1,40(sp)
    8000500e:	6121                	addi	sp,sp,64
    80005010:	8082                	ret
	...

0000000080005020 <kernelvec>:
    80005020:	7111                	addi	sp,sp,-256
    80005022:	e006                	sd	ra,0(sp)
    80005024:	e40a                	sd	sp,8(sp)
    80005026:	e80e                	sd	gp,16(sp)
    80005028:	ec12                	sd	tp,24(sp)
    8000502a:	f016                	sd	t0,32(sp)
    8000502c:	f41a                	sd	t1,40(sp)
    8000502e:	f81e                	sd	t2,48(sp)
    80005030:	fc22                	sd	s0,56(sp)
    80005032:	e0a6                	sd	s1,64(sp)
    80005034:	e4aa                	sd	a0,72(sp)
    80005036:	e8ae                	sd	a1,80(sp)
    80005038:	ecb2                	sd	a2,88(sp)
    8000503a:	f0b6                	sd	a3,96(sp)
    8000503c:	f4ba                	sd	a4,104(sp)
    8000503e:	f8be                	sd	a5,112(sp)
    80005040:	fcc2                	sd	a6,120(sp)
    80005042:	e146                	sd	a7,128(sp)
    80005044:	e54a                	sd	s2,136(sp)
    80005046:	e94e                	sd	s3,144(sp)
    80005048:	ed52                	sd	s4,152(sp)
    8000504a:	f156                	sd	s5,160(sp)
    8000504c:	f55a                	sd	s6,168(sp)
    8000504e:	f95e                	sd	s7,176(sp)
    80005050:	fd62                	sd	s8,184(sp)
    80005052:	e1e6                	sd	s9,192(sp)
    80005054:	e5ea                	sd	s10,200(sp)
    80005056:	e9ee                	sd	s11,208(sp)
    80005058:	edf2                	sd	t3,216(sp)
    8000505a:	f1f6                	sd	t4,224(sp)
    8000505c:	f5fa                	sd	t5,232(sp)
    8000505e:	f9fe                	sd	t6,240(sp)
    80005060:	d91fc0ef          	jal	ra,80001df0 <kerneltrap>
    80005064:	6082                	ld	ra,0(sp)
    80005066:	6122                	ld	sp,8(sp)
    80005068:	61c2                	ld	gp,16(sp)
    8000506a:	7282                	ld	t0,32(sp)
    8000506c:	7322                	ld	t1,40(sp)
    8000506e:	73c2                	ld	t2,48(sp)
    80005070:	7462                	ld	s0,56(sp)
    80005072:	6486                	ld	s1,64(sp)
    80005074:	6526                	ld	a0,72(sp)
    80005076:	65c6                	ld	a1,80(sp)
    80005078:	6666                	ld	a2,88(sp)
    8000507a:	7686                	ld	a3,96(sp)
    8000507c:	7726                	ld	a4,104(sp)
    8000507e:	77c6                	ld	a5,112(sp)
    80005080:	7866                	ld	a6,120(sp)
    80005082:	688a                	ld	a7,128(sp)
    80005084:	692a                	ld	s2,136(sp)
    80005086:	69ca                	ld	s3,144(sp)
    80005088:	6a6a                	ld	s4,152(sp)
    8000508a:	7a8a                	ld	s5,160(sp)
    8000508c:	7b2a                	ld	s6,168(sp)
    8000508e:	7bca                	ld	s7,176(sp)
    80005090:	7c6a                	ld	s8,184(sp)
    80005092:	6c8e                	ld	s9,192(sp)
    80005094:	6d2e                	ld	s10,200(sp)
    80005096:	6dce                	ld	s11,208(sp)
    80005098:	6e6e                	ld	t3,216(sp)
    8000509a:	7e8e                	ld	t4,224(sp)
    8000509c:	7f2e                	ld	t5,232(sp)
    8000509e:	7fce                	ld	t6,240(sp)
    800050a0:	6111                	addi	sp,sp,256
    800050a2:	10200073          	sret
    800050a6:	00000013          	nop
    800050aa:	00000013          	nop
    800050ae:	0001                	nop

00000000800050b0 <timervec>:
    800050b0:	34051573          	csrrw	a0,mscratch,a0
    800050b4:	e10c                	sd	a1,0(a0)
    800050b6:	e510                	sd	a2,8(a0)
    800050b8:	e914                	sd	a3,16(a0)
    800050ba:	6d0c                	ld	a1,24(a0)
    800050bc:	7110                	ld	a2,32(a0)
    800050be:	6194                	ld	a3,0(a1)
    800050c0:	96b2                	add	a3,a3,a2
    800050c2:	e194                	sd	a3,0(a1)
    800050c4:	4589                	li	a1,2
    800050c6:	14459073          	csrw	sip,a1
    800050ca:	6914                	ld	a3,16(a0)
    800050cc:	6510                	ld	a2,8(a0)
    800050ce:	610c                	ld	a1,0(a0)
    800050d0:	34051573          	csrrw	a0,mscratch,a0
    800050d4:	30200073          	mret
	...

00000000800050da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050da:	1141                	addi	sp,sp,-16
    800050dc:	e422                	sd	s0,8(sp)
    800050de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800050e0:	0c0007b7          	lui	a5,0xc000
    800050e4:	4705                	li	a4,1
    800050e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800050e8:	c3d8                	sw	a4,4(a5)
}
    800050ea:	6422                	ld	s0,8(sp)
    800050ec:	0141                	addi	sp,sp,16
    800050ee:	8082                	ret

00000000800050f0 <plicinithart>:

void
plicinithart(void)
{
    800050f0:	1141                	addi	sp,sp,-16
    800050f2:	e406                	sd	ra,8(sp)
    800050f4:	e022                	sd	s0,0(sp)
    800050f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050f8:	ffffc097          	auipc	ra,0xffffc
    800050fc:	d86080e7          	jalr	-634(ra) # 80000e7e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005100:	0085171b          	slliw	a4,a0,0x8
    80005104:	0c0027b7          	lui	a5,0xc002
    80005108:	97ba                	add	a5,a5,a4
    8000510a:	40200713          	li	a4,1026
    8000510e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005112:	00d5151b          	slliw	a0,a0,0xd
    80005116:	0c2017b7          	lui	a5,0xc201
    8000511a:	953e                	add	a0,a0,a5
    8000511c:	00052023          	sw	zero,0(a0)
}
    80005120:	60a2                	ld	ra,8(sp)
    80005122:	6402                	ld	s0,0(sp)
    80005124:	0141                	addi	sp,sp,16
    80005126:	8082                	ret

0000000080005128 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005128:	1141                	addi	sp,sp,-16
    8000512a:	e406                	sd	ra,8(sp)
    8000512c:	e022                	sd	s0,0(sp)
    8000512e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005130:	ffffc097          	auipc	ra,0xffffc
    80005134:	d4e080e7          	jalr	-690(ra) # 80000e7e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005138:	00d5179b          	slliw	a5,a0,0xd
    8000513c:	0c201537          	lui	a0,0xc201
    80005140:	953e                	add	a0,a0,a5
  return irq;
}
    80005142:	4148                	lw	a0,4(a0)
    80005144:	60a2                	ld	ra,8(sp)
    80005146:	6402                	ld	s0,0(sp)
    80005148:	0141                	addi	sp,sp,16
    8000514a:	8082                	ret

000000008000514c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000514c:	1101                	addi	sp,sp,-32
    8000514e:	ec06                	sd	ra,24(sp)
    80005150:	e822                	sd	s0,16(sp)
    80005152:	e426                	sd	s1,8(sp)
    80005154:	1000                	addi	s0,sp,32
    80005156:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005158:	ffffc097          	auipc	ra,0xffffc
    8000515c:	d26080e7          	jalr	-730(ra) # 80000e7e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005160:	00d5151b          	slliw	a0,a0,0xd
    80005164:	0c2017b7          	lui	a5,0xc201
    80005168:	97aa                	add	a5,a5,a0
    8000516a:	c3c4                	sw	s1,4(a5)
}
    8000516c:	60e2                	ld	ra,24(sp)
    8000516e:	6442                	ld	s0,16(sp)
    80005170:	64a2                	ld	s1,8(sp)
    80005172:	6105                	addi	sp,sp,32
    80005174:	8082                	ret

0000000080005176 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005176:	1141                	addi	sp,sp,-16
    80005178:	e406                	sd	ra,8(sp)
    8000517a:	e022                	sd	s0,0(sp)
    8000517c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000517e:	479d                	li	a5,7
    80005180:	04a7cc63          	blt	a5,a0,800051d8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005184:	00015797          	auipc	a5,0x15
    80005188:	86c78793          	addi	a5,a5,-1940 # 800199f0 <disk>
    8000518c:	97aa                	add	a5,a5,a0
    8000518e:	0187c783          	lbu	a5,24(a5)
    80005192:	ebb9                	bnez	a5,800051e8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005194:	00451613          	slli	a2,a0,0x4
    80005198:	00015797          	auipc	a5,0x15
    8000519c:	85878793          	addi	a5,a5,-1960 # 800199f0 <disk>
    800051a0:	6394                	ld	a3,0(a5)
    800051a2:	96b2                	add	a3,a3,a2
    800051a4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051a8:	6398                	ld	a4,0(a5)
    800051aa:	9732                	add	a4,a4,a2
    800051ac:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800051b0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800051b4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800051b8:	953e                	add	a0,a0,a5
    800051ba:	4785                	li	a5,1
    800051bc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800051c0:	00015517          	auipc	a0,0x15
    800051c4:	84850513          	addi	a0,a0,-1976 # 80019a08 <disk+0x18>
    800051c8:	ffffc097          	auipc	ra,0xffffc
    800051cc:	3f2080e7          	jalr	1010(ra) # 800015ba <wakeup>
}
    800051d0:	60a2                	ld	ra,8(sp)
    800051d2:	6402                	ld	s0,0(sp)
    800051d4:	0141                	addi	sp,sp,16
    800051d6:	8082                	ret
    panic("free_desc 1");
    800051d8:	00003517          	auipc	a0,0x3
    800051dc:	52850513          	addi	a0,a0,1320 # 80008700 <syscalls+0x2f0>
    800051e0:	00001097          	auipc	ra,0x1
    800051e4:	a0e080e7          	jalr	-1522(ra) # 80005bee <panic>
    panic("free_desc 2");
    800051e8:	00003517          	auipc	a0,0x3
    800051ec:	52850513          	addi	a0,a0,1320 # 80008710 <syscalls+0x300>
    800051f0:	00001097          	auipc	ra,0x1
    800051f4:	9fe080e7          	jalr	-1538(ra) # 80005bee <panic>

00000000800051f8 <virtio_disk_init>:
{
    800051f8:	1101                	addi	sp,sp,-32
    800051fa:	ec06                	sd	ra,24(sp)
    800051fc:	e822                	sd	s0,16(sp)
    800051fe:	e426                	sd	s1,8(sp)
    80005200:	e04a                	sd	s2,0(sp)
    80005202:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005204:	00003597          	auipc	a1,0x3
    80005208:	51c58593          	addi	a1,a1,1308 # 80008720 <syscalls+0x310>
    8000520c:	00015517          	auipc	a0,0x15
    80005210:	90c50513          	addi	a0,a0,-1780 # 80019b18 <disk+0x128>
    80005214:	00001097          	auipc	ra,0x1
    80005218:	e86080e7          	jalr	-378(ra) # 8000609a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000521c:	100017b7          	lui	a5,0x10001
    80005220:	4398                	lw	a4,0(a5)
    80005222:	2701                	sext.w	a4,a4
    80005224:	747277b7          	lui	a5,0x74727
    80005228:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000522c:	14f71c63          	bne	a4,a5,80005384 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005230:	100017b7          	lui	a5,0x10001
    80005234:	43dc                	lw	a5,4(a5)
    80005236:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005238:	4709                	li	a4,2
    8000523a:	14e79563          	bne	a5,a4,80005384 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000523e:	100017b7          	lui	a5,0x10001
    80005242:	479c                	lw	a5,8(a5)
    80005244:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005246:	12e79f63          	bne	a5,a4,80005384 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000524a:	100017b7          	lui	a5,0x10001
    8000524e:	47d8                	lw	a4,12(a5)
    80005250:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005252:	554d47b7          	lui	a5,0x554d4
    80005256:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000525a:	12f71563          	bne	a4,a5,80005384 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000525e:	100017b7          	lui	a5,0x10001
    80005262:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005266:	4705                	li	a4,1
    80005268:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000526a:	470d                	li	a4,3
    8000526c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000526e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005270:	c7ffe737          	lui	a4,0xc7ffe
    80005274:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9ef>
    80005278:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000527a:	2701                	sext.w	a4,a4
    8000527c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000527e:	472d                	li	a4,11
    80005280:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005282:	5bbc                	lw	a5,112(a5)
    80005284:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005288:	8ba1                	andi	a5,a5,8
    8000528a:	10078563          	beqz	a5,80005394 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000528e:	100017b7          	lui	a5,0x10001
    80005292:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005296:	43fc                	lw	a5,68(a5)
    80005298:	2781                	sext.w	a5,a5
    8000529a:	10079563          	bnez	a5,800053a4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000529e:	100017b7          	lui	a5,0x10001
    800052a2:	5bdc                	lw	a5,52(a5)
    800052a4:	2781                	sext.w	a5,a5
  if(max == 0)
    800052a6:	10078763          	beqz	a5,800053b4 <virtio_disk_init+0x1bc>
  if(max < NUM)
    800052aa:	471d                	li	a4,7
    800052ac:	10f77c63          	bgeu	a4,a5,800053c4 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    800052b0:	ffffb097          	auipc	ra,0xffffb
    800052b4:	e68080e7          	jalr	-408(ra) # 80000118 <kalloc>
    800052b8:	00014497          	auipc	s1,0x14
    800052bc:	73848493          	addi	s1,s1,1848 # 800199f0 <disk>
    800052c0:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800052c2:	ffffb097          	auipc	ra,0xffffb
    800052c6:	e56080e7          	jalr	-426(ra) # 80000118 <kalloc>
    800052ca:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800052cc:	ffffb097          	auipc	ra,0xffffb
    800052d0:	e4c080e7          	jalr	-436(ra) # 80000118 <kalloc>
    800052d4:	87aa                	mv	a5,a0
    800052d6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800052d8:	6088                	ld	a0,0(s1)
    800052da:	cd6d                	beqz	a0,800053d4 <virtio_disk_init+0x1dc>
    800052dc:	00014717          	auipc	a4,0x14
    800052e0:	71c73703          	ld	a4,1820(a4) # 800199f8 <disk+0x8>
    800052e4:	cb65                	beqz	a4,800053d4 <virtio_disk_init+0x1dc>
    800052e6:	c7fd                	beqz	a5,800053d4 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    800052e8:	6605                	lui	a2,0x1
    800052ea:	4581                	li	a1,0
    800052ec:	ffffb097          	auipc	ra,0xffffb
    800052f0:	e8c080e7          	jalr	-372(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    800052f4:	00014497          	auipc	s1,0x14
    800052f8:	6fc48493          	addi	s1,s1,1788 # 800199f0 <disk>
    800052fc:	6605                	lui	a2,0x1
    800052fe:	4581                	li	a1,0
    80005300:	6488                	ld	a0,8(s1)
    80005302:	ffffb097          	auipc	ra,0xffffb
    80005306:	e76080e7          	jalr	-394(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000530a:	6605                	lui	a2,0x1
    8000530c:	4581                	li	a1,0
    8000530e:	6888                	ld	a0,16(s1)
    80005310:	ffffb097          	auipc	ra,0xffffb
    80005314:	e68080e7          	jalr	-408(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005318:	100017b7          	lui	a5,0x10001
    8000531c:	4721                	li	a4,8
    8000531e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005320:	4098                	lw	a4,0(s1)
    80005322:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005326:	40d8                	lw	a4,4(s1)
    80005328:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000532c:	6498                	ld	a4,8(s1)
    8000532e:	0007069b          	sext.w	a3,a4
    80005332:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005336:	9701                	srai	a4,a4,0x20
    80005338:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000533c:	6898                	ld	a4,16(s1)
    8000533e:	0007069b          	sext.w	a3,a4
    80005342:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005346:	9701                	srai	a4,a4,0x20
    80005348:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000534c:	4705                	li	a4,1
    8000534e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005350:	00e48c23          	sb	a4,24(s1)
    80005354:	00e48ca3          	sb	a4,25(s1)
    80005358:	00e48d23          	sb	a4,26(s1)
    8000535c:	00e48da3          	sb	a4,27(s1)
    80005360:	00e48e23          	sb	a4,28(s1)
    80005364:	00e48ea3          	sb	a4,29(s1)
    80005368:	00e48f23          	sb	a4,30(s1)
    8000536c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005370:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005374:	0727a823          	sw	s2,112(a5)
}
    80005378:	60e2                	ld	ra,24(sp)
    8000537a:	6442                	ld	s0,16(sp)
    8000537c:	64a2                	ld	s1,8(sp)
    8000537e:	6902                	ld	s2,0(sp)
    80005380:	6105                	addi	sp,sp,32
    80005382:	8082                	ret
    panic("could not find virtio disk");
    80005384:	00003517          	auipc	a0,0x3
    80005388:	3ac50513          	addi	a0,a0,940 # 80008730 <syscalls+0x320>
    8000538c:	00001097          	auipc	ra,0x1
    80005390:	862080e7          	jalr	-1950(ra) # 80005bee <panic>
    panic("virtio disk FEATURES_OK unset");
    80005394:	00003517          	auipc	a0,0x3
    80005398:	3bc50513          	addi	a0,a0,956 # 80008750 <syscalls+0x340>
    8000539c:	00001097          	auipc	ra,0x1
    800053a0:	852080e7          	jalr	-1966(ra) # 80005bee <panic>
    panic("virtio disk should not be ready");
    800053a4:	00003517          	auipc	a0,0x3
    800053a8:	3cc50513          	addi	a0,a0,972 # 80008770 <syscalls+0x360>
    800053ac:	00001097          	auipc	ra,0x1
    800053b0:	842080e7          	jalr	-1982(ra) # 80005bee <panic>
    panic("virtio disk has no queue 0");
    800053b4:	00003517          	auipc	a0,0x3
    800053b8:	3dc50513          	addi	a0,a0,988 # 80008790 <syscalls+0x380>
    800053bc:	00001097          	auipc	ra,0x1
    800053c0:	832080e7          	jalr	-1998(ra) # 80005bee <panic>
    panic("virtio disk max queue too short");
    800053c4:	00003517          	auipc	a0,0x3
    800053c8:	3ec50513          	addi	a0,a0,1004 # 800087b0 <syscalls+0x3a0>
    800053cc:	00001097          	auipc	ra,0x1
    800053d0:	822080e7          	jalr	-2014(ra) # 80005bee <panic>
    panic("virtio disk kalloc");
    800053d4:	00003517          	auipc	a0,0x3
    800053d8:	3fc50513          	addi	a0,a0,1020 # 800087d0 <syscalls+0x3c0>
    800053dc:	00001097          	auipc	ra,0x1
    800053e0:	812080e7          	jalr	-2030(ra) # 80005bee <panic>

00000000800053e4 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053e4:	7119                	addi	sp,sp,-128
    800053e6:	fc86                	sd	ra,120(sp)
    800053e8:	f8a2                	sd	s0,112(sp)
    800053ea:	f4a6                	sd	s1,104(sp)
    800053ec:	f0ca                	sd	s2,96(sp)
    800053ee:	ecce                	sd	s3,88(sp)
    800053f0:	e8d2                	sd	s4,80(sp)
    800053f2:	e4d6                	sd	s5,72(sp)
    800053f4:	e0da                	sd	s6,64(sp)
    800053f6:	fc5e                	sd	s7,56(sp)
    800053f8:	f862                	sd	s8,48(sp)
    800053fa:	f466                	sd	s9,40(sp)
    800053fc:	f06a                	sd	s10,32(sp)
    800053fe:	ec6e                	sd	s11,24(sp)
    80005400:	0100                	addi	s0,sp,128
    80005402:	8aaa                	mv	s5,a0
    80005404:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005406:	00c52d03          	lw	s10,12(a0)
    8000540a:	001d1d1b          	slliw	s10,s10,0x1
    8000540e:	1d02                	slli	s10,s10,0x20
    80005410:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005414:	00014517          	auipc	a0,0x14
    80005418:	70450513          	addi	a0,a0,1796 # 80019b18 <disk+0x128>
    8000541c:	00001097          	auipc	ra,0x1
    80005420:	d0e080e7          	jalr	-754(ra) # 8000612a <acquire>
  for(int i = 0; i < 3; i++){
    80005424:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005426:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005428:	00014b97          	auipc	s7,0x14
    8000542c:	5c8b8b93          	addi	s7,s7,1480 # 800199f0 <disk>
  for(int i = 0; i < 3; i++){
    80005430:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005432:	00014c97          	auipc	s9,0x14
    80005436:	6e6c8c93          	addi	s9,s9,1766 # 80019b18 <disk+0x128>
    8000543a:	a08d                	j	8000549c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000543c:	00fb8733          	add	a4,s7,a5
    80005440:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005444:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005446:	0207c563          	bltz	a5,80005470 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000544a:	2905                	addiw	s2,s2,1
    8000544c:	0611                	addi	a2,a2,4
    8000544e:	05690c63          	beq	s2,s6,800054a6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005452:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005454:	00014717          	auipc	a4,0x14
    80005458:	59c70713          	addi	a4,a4,1436 # 800199f0 <disk>
    8000545c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000545e:	01874683          	lbu	a3,24(a4)
    80005462:	fee9                	bnez	a3,8000543c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005464:	2785                	addiw	a5,a5,1
    80005466:	0705                	addi	a4,a4,1
    80005468:	fe979be3          	bne	a5,s1,8000545e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000546c:	57fd                	li	a5,-1
    8000546e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005470:	01205d63          	blez	s2,8000548a <virtio_disk_rw+0xa6>
    80005474:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005476:	000a2503          	lw	a0,0(s4)
    8000547a:	00000097          	auipc	ra,0x0
    8000547e:	cfc080e7          	jalr	-772(ra) # 80005176 <free_desc>
      for(int j = 0; j < i; j++)
    80005482:	2d85                	addiw	s11,s11,1
    80005484:	0a11                	addi	s4,s4,4
    80005486:	ffb918e3          	bne	s2,s11,80005476 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000548a:	85e6                	mv	a1,s9
    8000548c:	00014517          	auipc	a0,0x14
    80005490:	57c50513          	addi	a0,a0,1404 # 80019a08 <disk+0x18>
    80005494:	ffffc097          	auipc	ra,0xffffc
    80005498:	0c2080e7          	jalr	194(ra) # 80001556 <sleep>
  for(int i = 0; i < 3; i++){
    8000549c:	f8040a13          	addi	s4,s0,-128
{
    800054a0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800054a2:	894e                	mv	s2,s3
    800054a4:	b77d                	j	80005452 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054a6:	f8042583          	lw	a1,-128(s0)
    800054aa:	00a58793          	addi	a5,a1,10
    800054ae:	0792                	slli	a5,a5,0x4

  if(write)
    800054b0:	00014617          	auipc	a2,0x14
    800054b4:	54060613          	addi	a2,a2,1344 # 800199f0 <disk>
    800054b8:	00f60733          	add	a4,a2,a5
    800054bc:	018036b3          	snez	a3,s8
    800054c0:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054c2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800054c6:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054ca:	f6078693          	addi	a3,a5,-160
    800054ce:	6218                	ld	a4,0(a2)
    800054d0:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054d2:	00878513          	addi	a0,a5,8
    800054d6:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    800054d8:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054da:	6208                	ld	a0,0(a2)
    800054dc:	96aa                	add	a3,a3,a0
    800054de:	4741                	li	a4,16
    800054e0:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054e2:	4705                	li	a4,1
    800054e4:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800054e8:	f8442703          	lw	a4,-124(s0)
    800054ec:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054f0:	0712                	slli	a4,a4,0x4
    800054f2:	953a                	add	a0,a0,a4
    800054f4:	058a8693          	addi	a3,s5,88
    800054f8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800054fa:	6208                	ld	a0,0(a2)
    800054fc:	972a                	add	a4,a4,a0
    800054fe:	40000693          	li	a3,1024
    80005502:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005504:	001c3c13          	seqz	s8,s8
    80005508:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000550a:	001c6c13          	ori	s8,s8,1
    8000550e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005512:	f8842603          	lw	a2,-120(s0)
    80005516:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000551a:	00014697          	auipc	a3,0x14
    8000551e:	4d668693          	addi	a3,a3,1238 # 800199f0 <disk>
    80005522:	00258713          	addi	a4,a1,2
    80005526:	0712                	slli	a4,a4,0x4
    80005528:	9736                	add	a4,a4,a3
    8000552a:	587d                	li	a6,-1
    8000552c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005530:	0612                	slli	a2,a2,0x4
    80005532:	9532                	add	a0,a0,a2
    80005534:	f9078793          	addi	a5,a5,-112
    80005538:	97b6                	add	a5,a5,a3
    8000553a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000553c:	629c                	ld	a5,0(a3)
    8000553e:	97b2                	add	a5,a5,a2
    80005540:	4605                	li	a2,1
    80005542:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005544:	4509                	li	a0,2
    80005546:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    8000554a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000554e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005552:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005556:	6698                	ld	a4,8(a3)
    80005558:	00275783          	lhu	a5,2(a4)
    8000555c:	8b9d                	andi	a5,a5,7
    8000555e:	0786                	slli	a5,a5,0x1
    80005560:	97ba                	add	a5,a5,a4
    80005562:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005566:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000556a:	6698                	ld	a4,8(a3)
    8000556c:	00275783          	lhu	a5,2(a4)
    80005570:	2785                	addiw	a5,a5,1
    80005572:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005576:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000557a:	100017b7          	lui	a5,0x10001
    8000557e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005582:	004aa783          	lw	a5,4(s5)
    80005586:	02c79163          	bne	a5,a2,800055a8 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000558a:	00014917          	auipc	s2,0x14
    8000558e:	58e90913          	addi	s2,s2,1422 # 80019b18 <disk+0x128>
  while(b->disk == 1) {
    80005592:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005594:	85ca                	mv	a1,s2
    80005596:	8556                	mv	a0,s5
    80005598:	ffffc097          	auipc	ra,0xffffc
    8000559c:	fbe080e7          	jalr	-66(ra) # 80001556 <sleep>
  while(b->disk == 1) {
    800055a0:	004aa783          	lw	a5,4(s5)
    800055a4:	fe9788e3          	beq	a5,s1,80005594 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800055a8:	f8042903          	lw	s2,-128(s0)
    800055ac:	00290793          	addi	a5,s2,2
    800055b0:	00479713          	slli	a4,a5,0x4
    800055b4:	00014797          	auipc	a5,0x14
    800055b8:	43c78793          	addi	a5,a5,1084 # 800199f0 <disk>
    800055bc:	97ba                	add	a5,a5,a4
    800055be:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800055c2:	00014997          	auipc	s3,0x14
    800055c6:	42e98993          	addi	s3,s3,1070 # 800199f0 <disk>
    800055ca:	00491713          	slli	a4,s2,0x4
    800055ce:	0009b783          	ld	a5,0(s3)
    800055d2:	97ba                	add	a5,a5,a4
    800055d4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055d8:	854a                	mv	a0,s2
    800055da:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055de:	00000097          	auipc	ra,0x0
    800055e2:	b98080e7          	jalr	-1128(ra) # 80005176 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055e6:	8885                	andi	s1,s1,1
    800055e8:	f0ed                	bnez	s1,800055ca <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055ea:	00014517          	auipc	a0,0x14
    800055ee:	52e50513          	addi	a0,a0,1326 # 80019b18 <disk+0x128>
    800055f2:	00001097          	auipc	ra,0x1
    800055f6:	bec080e7          	jalr	-1044(ra) # 800061de <release>
}
    800055fa:	70e6                	ld	ra,120(sp)
    800055fc:	7446                	ld	s0,112(sp)
    800055fe:	74a6                	ld	s1,104(sp)
    80005600:	7906                	ld	s2,96(sp)
    80005602:	69e6                	ld	s3,88(sp)
    80005604:	6a46                	ld	s4,80(sp)
    80005606:	6aa6                	ld	s5,72(sp)
    80005608:	6b06                	ld	s6,64(sp)
    8000560a:	7be2                	ld	s7,56(sp)
    8000560c:	7c42                	ld	s8,48(sp)
    8000560e:	7ca2                	ld	s9,40(sp)
    80005610:	7d02                	ld	s10,32(sp)
    80005612:	6de2                	ld	s11,24(sp)
    80005614:	6109                	addi	sp,sp,128
    80005616:	8082                	ret

0000000080005618 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005618:	1101                	addi	sp,sp,-32
    8000561a:	ec06                	sd	ra,24(sp)
    8000561c:	e822                	sd	s0,16(sp)
    8000561e:	e426                	sd	s1,8(sp)
    80005620:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005622:	00014497          	auipc	s1,0x14
    80005626:	3ce48493          	addi	s1,s1,974 # 800199f0 <disk>
    8000562a:	00014517          	auipc	a0,0x14
    8000562e:	4ee50513          	addi	a0,a0,1262 # 80019b18 <disk+0x128>
    80005632:	00001097          	auipc	ra,0x1
    80005636:	af8080e7          	jalr	-1288(ra) # 8000612a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000563a:	10001737          	lui	a4,0x10001
    8000563e:	533c                	lw	a5,96(a4)
    80005640:	8b8d                	andi	a5,a5,3
    80005642:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005644:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005648:	689c                	ld	a5,16(s1)
    8000564a:	0204d703          	lhu	a4,32(s1)
    8000564e:	0027d783          	lhu	a5,2(a5)
    80005652:	04f70863          	beq	a4,a5,800056a2 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005656:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000565a:	6898                	ld	a4,16(s1)
    8000565c:	0204d783          	lhu	a5,32(s1)
    80005660:	8b9d                	andi	a5,a5,7
    80005662:	078e                	slli	a5,a5,0x3
    80005664:	97ba                	add	a5,a5,a4
    80005666:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005668:	00278713          	addi	a4,a5,2
    8000566c:	0712                	slli	a4,a4,0x4
    8000566e:	9726                	add	a4,a4,s1
    80005670:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005674:	e721                	bnez	a4,800056bc <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005676:	0789                	addi	a5,a5,2
    80005678:	0792                	slli	a5,a5,0x4
    8000567a:	97a6                	add	a5,a5,s1
    8000567c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000567e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005682:	ffffc097          	auipc	ra,0xffffc
    80005686:	f38080e7          	jalr	-200(ra) # 800015ba <wakeup>

    disk.used_idx += 1;
    8000568a:	0204d783          	lhu	a5,32(s1)
    8000568e:	2785                	addiw	a5,a5,1
    80005690:	17c2                	slli	a5,a5,0x30
    80005692:	93c1                	srli	a5,a5,0x30
    80005694:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005698:	6898                	ld	a4,16(s1)
    8000569a:	00275703          	lhu	a4,2(a4)
    8000569e:	faf71ce3          	bne	a4,a5,80005656 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800056a2:	00014517          	auipc	a0,0x14
    800056a6:	47650513          	addi	a0,a0,1142 # 80019b18 <disk+0x128>
    800056aa:	00001097          	auipc	ra,0x1
    800056ae:	b34080e7          	jalr	-1228(ra) # 800061de <release>
}
    800056b2:	60e2                	ld	ra,24(sp)
    800056b4:	6442                	ld	s0,16(sp)
    800056b6:	64a2                	ld	s1,8(sp)
    800056b8:	6105                	addi	sp,sp,32
    800056ba:	8082                	ret
      panic("virtio_disk_intr status");
    800056bc:	00003517          	auipc	a0,0x3
    800056c0:	12c50513          	addi	a0,a0,300 # 800087e8 <syscalls+0x3d8>
    800056c4:	00000097          	auipc	ra,0x0
    800056c8:	52a080e7          	jalr	1322(ra) # 80005bee <panic>

00000000800056cc <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056cc:	1141                	addi	sp,sp,-16
    800056ce:	e422                	sd	s0,8(sp)
    800056d0:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056d2:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800056d6:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056da:	0037979b          	slliw	a5,a5,0x3
    800056de:	02004737          	lui	a4,0x2004
    800056e2:	97ba                	add	a5,a5,a4
    800056e4:	0200c737          	lui	a4,0x200c
    800056e8:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800056ec:	000f4637          	lui	a2,0xf4
    800056f0:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800056f4:	95b2                	add	a1,a1,a2
    800056f6:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800056f8:	00269713          	slli	a4,a3,0x2
    800056fc:	9736                	add	a4,a4,a3
    800056fe:	00371693          	slli	a3,a4,0x3
    80005702:	00014717          	auipc	a4,0x14
    80005706:	42e70713          	addi	a4,a4,1070 # 80019b30 <timer_scratch>
    8000570a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000570c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000570e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005710:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005714:	00000797          	auipc	a5,0x0
    80005718:	99c78793          	addi	a5,a5,-1636 # 800050b0 <timervec>
    8000571c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005720:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005724:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005728:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000572c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005730:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005734:	30479073          	csrw	mie,a5
}
    80005738:	6422                	ld	s0,8(sp)
    8000573a:	0141                	addi	sp,sp,16
    8000573c:	8082                	ret

000000008000573e <start>:
{
    8000573e:	1141                	addi	sp,sp,-16
    80005740:	e406                	sd	ra,8(sp)
    80005742:	e022                	sd	s0,0(sp)
    80005744:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005746:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000574a:	7779                	lui	a4,0xffffe
    8000574c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca8f>
    80005750:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005752:	6705                	lui	a4,0x1
    80005754:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005758:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000575a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000575e:	ffffb797          	auipc	a5,0xffffb
    80005762:	bc078793          	addi	a5,a5,-1088 # 8000031e <main>
    80005766:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000576a:	4781                	li	a5,0
    8000576c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005770:	67c1                	lui	a5,0x10
    80005772:	17fd                	addi	a5,a5,-1
    80005774:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005778:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000577c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005780:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005784:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005788:	57fd                	li	a5,-1
    8000578a:	83a9                	srli	a5,a5,0xa
    8000578c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005790:	47bd                	li	a5,15
    80005792:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005796:	00000097          	auipc	ra,0x0
    8000579a:	f36080e7          	jalr	-202(ra) # 800056cc <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000579e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057a2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057a4:	823e                	mv	tp,a5
  asm volatile("mret");
    800057a6:	30200073          	mret
}
    800057aa:	60a2                	ld	ra,8(sp)
    800057ac:	6402                	ld	s0,0(sp)
    800057ae:	0141                	addi	sp,sp,16
    800057b0:	8082                	ret

00000000800057b2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057b2:	715d                	addi	sp,sp,-80
    800057b4:	e486                	sd	ra,72(sp)
    800057b6:	e0a2                	sd	s0,64(sp)
    800057b8:	fc26                	sd	s1,56(sp)
    800057ba:	f84a                	sd	s2,48(sp)
    800057bc:	f44e                	sd	s3,40(sp)
    800057be:	f052                	sd	s4,32(sp)
    800057c0:	ec56                	sd	s5,24(sp)
    800057c2:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057c4:	04c05663          	blez	a2,80005810 <consolewrite+0x5e>
    800057c8:	8a2a                	mv	s4,a0
    800057ca:	84ae                	mv	s1,a1
    800057cc:	89b2                	mv	s3,a2
    800057ce:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057d0:	5afd                	li	s5,-1
    800057d2:	4685                	li	a3,1
    800057d4:	8626                	mv	a2,s1
    800057d6:	85d2                	mv	a1,s4
    800057d8:	fbf40513          	addi	a0,s0,-65
    800057dc:	ffffc097          	auipc	ra,0xffffc
    800057e0:	1d8080e7          	jalr	472(ra) # 800019b4 <either_copyin>
    800057e4:	01550c63          	beq	a0,s5,800057fc <consolewrite+0x4a>
      break;
    uartputc(c);
    800057e8:	fbf44503          	lbu	a0,-65(s0)
    800057ec:	00000097          	auipc	ra,0x0
    800057f0:	780080e7          	jalr	1920(ra) # 80005f6c <uartputc>
  for(i = 0; i < n; i++){
    800057f4:	2905                	addiw	s2,s2,1
    800057f6:	0485                	addi	s1,s1,1
    800057f8:	fd299de3          	bne	s3,s2,800057d2 <consolewrite+0x20>
  }

  return i;
}
    800057fc:	854a                	mv	a0,s2
    800057fe:	60a6                	ld	ra,72(sp)
    80005800:	6406                	ld	s0,64(sp)
    80005802:	74e2                	ld	s1,56(sp)
    80005804:	7942                	ld	s2,48(sp)
    80005806:	79a2                	ld	s3,40(sp)
    80005808:	7a02                	ld	s4,32(sp)
    8000580a:	6ae2                	ld	s5,24(sp)
    8000580c:	6161                	addi	sp,sp,80
    8000580e:	8082                	ret
  for(i = 0; i < n; i++){
    80005810:	4901                	li	s2,0
    80005812:	b7ed                	j	800057fc <consolewrite+0x4a>

0000000080005814 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005814:	7159                	addi	sp,sp,-112
    80005816:	f486                	sd	ra,104(sp)
    80005818:	f0a2                	sd	s0,96(sp)
    8000581a:	eca6                	sd	s1,88(sp)
    8000581c:	e8ca                	sd	s2,80(sp)
    8000581e:	e4ce                	sd	s3,72(sp)
    80005820:	e0d2                	sd	s4,64(sp)
    80005822:	fc56                	sd	s5,56(sp)
    80005824:	f85a                	sd	s6,48(sp)
    80005826:	f45e                	sd	s7,40(sp)
    80005828:	f062                	sd	s8,32(sp)
    8000582a:	ec66                	sd	s9,24(sp)
    8000582c:	e86a                	sd	s10,16(sp)
    8000582e:	1880                	addi	s0,sp,112
    80005830:	8aaa                	mv	s5,a0
    80005832:	8a2e                	mv	s4,a1
    80005834:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005836:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000583a:	0001c517          	auipc	a0,0x1c
    8000583e:	43650513          	addi	a0,a0,1078 # 80021c70 <cons>
    80005842:	00001097          	auipc	ra,0x1
    80005846:	8e8080e7          	jalr	-1816(ra) # 8000612a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000584a:	0001c497          	auipc	s1,0x1c
    8000584e:	42648493          	addi	s1,s1,1062 # 80021c70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005852:	0001c917          	auipc	s2,0x1c
    80005856:	4b690913          	addi	s2,s2,1206 # 80021d08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000585a:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000585c:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000585e:	4ca9                	li	s9,10
  while(n > 0){
    80005860:	07305b63          	blez	s3,800058d6 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005864:	0984a783          	lw	a5,152(s1)
    80005868:	09c4a703          	lw	a4,156(s1)
    8000586c:	02f71763          	bne	a4,a5,8000589a <consoleread+0x86>
      if(killed(myproc())){
    80005870:	ffffb097          	auipc	ra,0xffffb
    80005874:	63a080e7          	jalr	1594(ra) # 80000eaa <myproc>
    80005878:	ffffc097          	auipc	ra,0xffffc
    8000587c:	f86080e7          	jalr	-122(ra) # 800017fe <killed>
    80005880:	e535                	bnez	a0,800058ec <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005882:	85a6                	mv	a1,s1
    80005884:	854a                	mv	a0,s2
    80005886:	ffffc097          	auipc	ra,0xffffc
    8000588a:	cd0080e7          	jalr	-816(ra) # 80001556 <sleep>
    while(cons.r == cons.w){
    8000588e:	0984a783          	lw	a5,152(s1)
    80005892:	09c4a703          	lw	a4,156(s1)
    80005896:	fcf70de3          	beq	a4,a5,80005870 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000589a:	0017871b          	addiw	a4,a5,1
    8000589e:	08e4ac23          	sw	a4,152(s1)
    800058a2:	07f7f713          	andi	a4,a5,127
    800058a6:	9726                	add	a4,a4,s1
    800058a8:	01874703          	lbu	a4,24(a4)
    800058ac:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800058b0:	077d0563          	beq	s10,s7,8000591a <consoleread+0x106>
    cbuf = c;
    800058b4:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058b8:	4685                	li	a3,1
    800058ba:	f9f40613          	addi	a2,s0,-97
    800058be:	85d2                	mv	a1,s4
    800058c0:	8556                	mv	a0,s5
    800058c2:	ffffc097          	auipc	ra,0xffffc
    800058c6:	09c080e7          	jalr	156(ra) # 8000195e <either_copyout>
    800058ca:	01850663          	beq	a0,s8,800058d6 <consoleread+0xc2>
    dst++;
    800058ce:	0a05                	addi	s4,s4,1
    --n;
    800058d0:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800058d2:	f99d17e3          	bne	s10,s9,80005860 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800058d6:	0001c517          	auipc	a0,0x1c
    800058da:	39a50513          	addi	a0,a0,922 # 80021c70 <cons>
    800058de:	00001097          	auipc	ra,0x1
    800058e2:	900080e7          	jalr	-1792(ra) # 800061de <release>

  return target - n;
    800058e6:	413b053b          	subw	a0,s6,s3
    800058ea:	a811                	j	800058fe <consoleread+0xea>
        release(&cons.lock);
    800058ec:	0001c517          	auipc	a0,0x1c
    800058f0:	38450513          	addi	a0,a0,900 # 80021c70 <cons>
    800058f4:	00001097          	auipc	ra,0x1
    800058f8:	8ea080e7          	jalr	-1814(ra) # 800061de <release>
        return -1;
    800058fc:	557d                	li	a0,-1
}
    800058fe:	70a6                	ld	ra,104(sp)
    80005900:	7406                	ld	s0,96(sp)
    80005902:	64e6                	ld	s1,88(sp)
    80005904:	6946                	ld	s2,80(sp)
    80005906:	69a6                	ld	s3,72(sp)
    80005908:	6a06                	ld	s4,64(sp)
    8000590a:	7ae2                	ld	s5,56(sp)
    8000590c:	7b42                	ld	s6,48(sp)
    8000590e:	7ba2                	ld	s7,40(sp)
    80005910:	7c02                	ld	s8,32(sp)
    80005912:	6ce2                	ld	s9,24(sp)
    80005914:	6d42                	ld	s10,16(sp)
    80005916:	6165                	addi	sp,sp,112
    80005918:	8082                	ret
      if(n < target){
    8000591a:	0009871b          	sext.w	a4,s3
    8000591e:	fb677ce3          	bgeu	a4,s6,800058d6 <consoleread+0xc2>
        cons.r--;
    80005922:	0001c717          	auipc	a4,0x1c
    80005926:	3ef72323          	sw	a5,998(a4) # 80021d08 <cons+0x98>
    8000592a:	b775                	j	800058d6 <consoleread+0xc2>

000000008000592c <consputc>:
{
    8000592c:	1141                	addi	sp,sp,-16
    8000592e:	e406                	sd	ra,8(sp)
    80005930:	e022                	sd	s0,0(sp)
    80005932:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005934:	10000793          	li	a5,256
    80005938:	00f50a63          	beq	a0,a5,8000594c <consputc+0x20>
    uartputc_sync(c);
    8000593c:	00000097          	auipc	ra,0x0
    80005940:	55e080e7          	jalr	1374(ra) # 80005e9a <uartputc_sync>
}
    80005944:	60a2                	ld	ra,8(sp)
    80005946:	6402                	ld	s0,0(sp)
    80005948:	0141                	addi	sp,sp,16
    8000594a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000594c:	4521                	li	a0,8
    8000594e:	00000097          	auipc	ra,0x0
    80005952:	54c080e7          	jalr	1356(ra) # 80005e9a <uartputc_sync>
    80005956:	02000513          	li	a0,32
    8000595a:	00000097          	auipc	ra,0x0
    8000595e:	540080e7          	jalr	1344(ra) # 80005e9a <uartputc_sync>
    80005962:	4521                	li	a0,8
    80005964:	00000097          	auipc	ra,0x0
    80005968:	536080e7          	jalr	1334(ra) # 80005e9a <uartputc_sync>
    8000596c:	bfe1                	j	80005944 <consputc+0x18>

000000008000596e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000596e:	1101                	addi	sp,sp,-32
    80005970:	ec06                	sd	ra,24(sp)
    80005972:	e822                	sd	s0,16(sp)
    80005974:	e426                	sd	s1,8(sp)
    80005976:	e04a                	sd	s2,0(sp)
    80005978:	1000                	addi	s0,sp,32
    8000597a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000597c:	0001c517          	auipc	a0,0x1c
    80005980:	2f450513          	addi	a0,a0,756 # 80021c70 <cons>
    80005984:	00000097          	auipc	ra,0x0
    80005988:	7a6080e7          	jalr	1958(ra) # 8000612a <acquire>

  switch(c){
    8000598c:	47d5                	li	a5,21
    8000598e:	0af48663          	beq	s1,a5,80005a3a <consoleintr+0xcc>
    80005992:	0297ca63          	blt	a5,s1,800059c6 <consoleintr+0x58>
    80005996:	47a1                	li	a5,8
    80005998:	0ef48763          	beq	s1,a5,80005a86 <consoleintr+0x118>
    8000599c:	47c1                	li	a5,16
    8000599e:	10f49a63          	bne	s1,a5,80005ab2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059a2:	ffffc097          	auipc	ra,0xffffc
    800059a6:	068080e7          	jalr	104(ra) # 80001a0a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059aa:	0001c517          	auipc	a0,0x1c
    800059ae:	2c650513          	addi	a0,a0,710 # 80021c70 <cons>
    800059b2:	00001097          	auipc	ra,0x1
    800059b6:	82c080e7          	jalr	-2004(ra) # 800061de <release>
}
    800059ba:	60e2                	ld	ra,24(sp)
    800059bc:	6442                	ld	s0,16(sp)
    800059be:	64a2                	ld	s1,8(sp)
    800059c0:	6902                	ld	s2,0(sp)
    800059c2:	6105                	addi	sp,sp,32
    800059c4:	8082                	ret
  switch(c){
    800059c6:	07f00793          	li	a5,127
    800059ca:	0af48e63          	beq	s1,a5,80005a86 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800059ce:	0001c717          	auipc	a4,0x1c
    800059d2:	2a270713          	addi	a4,a4,674 # 80021c70 <cons>
    800059d6:	0a072783          	lw	a5,160(a4)
    800059da:	09872703          	lw	a4,152(a4)
    800059de:	9f99                	subw	a5,a5,a4
    800059e0:	07f00713          	li	a4,127
    800059e4:	fcf763e3          	bltu	a4,a5,800059aa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800059e8:	47b5                	li	a5,13
    800059ea:	0cf48763          	beq	s1,a5,80005ab8 <consoleintr+0x14a>
      consputc(c);
    800059ee:	8526                	mv	a0,s1
    800059f0:	00000097          	auipc	ra,0x0
    800059f4:	f3c080e7          	jalr	-196(ra) # 8000592c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800059f8:	0001c797          	auipc	a5,0x1c
    800059fc:	27878793          	addi	a5,a5,632 # 80021c70 <cons>
    80005a00:	0a07a683          	lw	a3,160(a5)
    80005a04:	0016871b          	addiw	a4,a3,1
    80005a08:	0007061b          	sext.w	a2,a4
    80005a0c:	0ae7a023          	sw	a4,160(a5)
    80005a10:	07f6f693          	andi	a3,a3,127
    80005a14:	97b6                	add	a5,a5,a3
    80005a16:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005a1a:	47a9                	li	a5,10
    80005a1c:	0cf48563          	beq	s1,a5,80005ae6 <consoleintr+0x178>
    80005a20:	4791                	li	a5,4
    80005a22:	0cf48263          	beq	s1,a5,80005ae6 <consoleintr+0x178>
    80005a26:	0001c797          	auipc	a5,0x1c
    80005a2a:	2e27a783          	lw	a5,738(a5) # 80021d08 <cons+0x98>
    80005a2e:	9f1d                	subw	a4,a4,a5
    80005a30:	08000793          	li	a5,128
    80005a34:	f6f71be3          	bne	a4,a5,800059aa <consoleintr+0x3c>
    80005a38:	a07d                	j	80005ae6 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a3a:	0001c717          	auipc	a4,0x1c
    80005a3e:	23670713          	addi	a4,a4,566 # 80021c70 <cons>
    80005a42:	0a072783          	lw	a5,160(a4)
    80005a46:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a4a:	0001c497          	auipc	s1,0x1c
    80005a4e:	22648493          	addi	s1,s1,550 # 80021c70 <cons>
    while(cons.e != cons.w &&
    80005a52:	4929                	li	s2,10
    80005a54:	f4f70be3          	beq	a4,a5,800059aa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a58:	37fd                	addiw	a5,a5,-1
    80005a5a:	07f7f713          	andi	a4,a5,127
    80005a5e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a60:	01874703          	lbu	a4,24(a4)
    80005a64:	f52703e3          	beq	a4,s2,800059aa <consoleintr+0x3c>
      cons.e--;
    80005a68:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a6c:	10000513          	li	a0,256
    80005a70:	00000097          	auipc	ra,0x0
    80005a74:	ebc080e7          	jalr	-324(ra) # 8000592c <consputc>
    while(cons.e != cons.w &&
    80005a78:	0a04a783          	lw	a5,160(s1)
    80005a7c:	09c4a703          	lw	a4,156(s1)
    80005a80:	fcf71ce3          	bne	a4,a5,80005a58 <consoleintr+0xea>
    80005a84:	b71d                	j	800059aa <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a86:	0001c717          	auipc	a4,0x1c
    80005a8a:	1ea70713          	addi	a4,a4,490 # 80021c70 <cons>
    80005a8e:	0a072783          	lw	a5,160(a4)
    80005a92:	09c72703          	lw	a4,156(a4)
    80005a96:	f0f70ae3          	beq	a4,a5,800059aa <consoleintr+0x3c>
      cons.e--;
    80005a9a:	37fd                	addiw	a5,a5,-1
    80005a9c:	0001c717          	auipc	a4,0x1c
    80005aa0:	26f72a23          	sw	a5,628(a4) # 80021d10 <cons+0xa0>
      consputc(BACKSPACE);
    80005aa4:	10000513          	li	a0,256
    80005aa8:	00000097          	auipc	ra,0x0
    80005aac:	e84080e7          	jalr	-380(ra) # 8000592c <consputc>
    80005ab0:	bded                	j	800059aa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ab2:	ee048ce3          	beqz	s1,800059aa <consoleintr+0x3c>
    80005ab6:	bf21                	j	800059ce <consoleintr+0x60>
      consputc(c);
    80005ab8:	4529                	li	a0,10
    80005aba:	00000097          	auipc	ra,0x0
    80005abe:	e72080e7          	jalr	-398(ra) # 8000592c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ac2:	0001c797          	auipc	a5,0x1c
    80005ac6:	1ae78793          	addi	a5,a5,430 # 80021c70 <cons>
    80005aca:	0a07a703          	lw	a4,160(a5)
    80005ace:	0017069b          	addiw	a3,a4,1
    80005ad2:	0006861b          	sext.w	a2,a3
    80005ad6:	0ad7a023          	sw	a3,160(a5)
    80005ada:	07f77713          	andi	a4,a4,127
    80005ade:	97ba                	add	a5,a5,a4
    80005ae0:	4729                	li	a4,10
    80005ae2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ae6:	0001c797          	auipc	a5,0x1c
    80005aea:	22c7a323          	sw	a2,550(a5) # 80021d0c <cons+0x9c>
        wakeup(&cons.r);
    80005aee:	0001c517          	auipc	a0,0x1c
    80005af2:	21a50513          	addi	a0,a0,538 # 80021d08 <cons+0x98>
    80005af6:	ffffc097          	auipc	ra,0xffffc
    80005afa:	ac4080e7          	jalr	-1340(ra) # 800015ba <wakeup>
    80005afe:	b575                	j	800059aa <consoleintr+0x3c>

0000000080005b00 <consoleinit>:

void
consoleinit(void)
{
    80005b00:	1141                	addi	sp,sp,-16
    80005b02:	e406                	sd	ra,8(sp)
    80005b04:	e022                	sd	s0,0(sp)
    80005b06:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b08:	00003597          	auipc	a1,0x3
    80005b0c:	cf858593          	addi	a1,a1,-776 # 80008800 <syscalls+0x3f0>
    80005b10:	0001c517          	auipc	a0,0x1c
    80005b14:	16050513          	addi	a0,a0,352 # 80021c70 <cons>
    80005b18:	00000097          	auipc	ra,0x0
    80005b1c:	582080e7          	jalr	1410(ra) # 8000609a <initlock>

  uartinit();
    80005b20:	00000097          	auipc	ra,0x0
    80005b24:	32a080e7          	jalr	810(ra) # 80005e4a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b28:	00013797          	auipc	a5,0x13
    80005b2c:	e7078793          	addi	a5,a5,-400 # 80018998 <devsw>
    80005b30:	00000717          	auipc	a4,0x0
    80005b34:	ce470713          	addi	a4,a4,-796 # 80005814 <consoleread>
    80005b38:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b3a:	00000717          	auipc	a4,0x0
    80005b3e:	c7870713          	addi	a4,a4,-904 # 800057b2 <consolewrite>
    80005b42:	ef98                	sd	a4,24(a5)
}
    80005b44:	60a2                	ld	ra,8(sp)
    80005b46:	6402                	ld	s0,0(sp)
    80005b48:	0141                	addi	sp,sp,16
    80005b4a:	8082                	ret

0000000080005b4c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b4c:	7179                	addi	sp,sp,-48
    80005b4e:	f406                	sd	ra,40(sp)
    80005b50:	f022                	sd	s0,32(sp)
    80005b52:	ec26                	sd	s1,24(sp)
    80005b54:	e84a                	sd	s2,16(sp)
    80005b56:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b58:	c219                	beqz	a2,80005b5e <printint+0x12>
    80005b5a:	08054663          	bltz	a0,80005be6 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005b5e:	2501                	sext.w	a0,a0
    80005b60:	4881                	li	a7,0
    80005b62:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b66:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b68:	2581                	sext.w	a1,a1
    80005b6a:	00003617          	auipc	a2,0x3
    80005b6e:	cc660613          	addi	a2,a2,-826 # 80008830 <digits>
    80005b72:	883a                	mv	a6,a4
    80005b74:	2705                	addiw	a4,a4,1
    80005b76:	02b577bb          	remuw	a5,a0,a1
    80005b7a:	1782                	slli	a5,a5,0x20
    80005b7c:	9381                	srli	a5,a5,0x20
    80005b7e:	97b2                	add	a5,a5,a2
    80005b80:	0007c783          	lbu	a5,0(a5)
    80005b84:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b88:	0005079b          	sext.w	a5,a0
    80005b8c:	02b5553b          	divuw	a0,a0,a1
    80005b90:	0685                	addi	a3,a3,1
    80005b92:	feb7f0e3          	bgeu	a5,a1,80005b72 <printint+0x26>

  if(sign)
    80005b96:	00088b63          	beqz	a7,80005bac <printint+0x60>
    buf[i++] = '-';
    80005b9a:	fe040793          	addi	a5,s0,-32
    80005b9e:	973e                	add	a4,a4,a5
    80005ba0:	02d00793          	li	a5,45
    80005ba4:	fef70823          	sb	a5,-16(a4)
    80005ba8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bac:	02e05763          	blez	a4,80005bda <printint+0x8e>
    80005bb0:	fd040793          	addi	a5,s0,-48
    80005bb4:	00e784b3          	add	s1,a5,a4
    80005bb8:	fff78913          	addi	s2,a5,-1
    80005bbc:	993a                	add	s2,s2,a4
    80005bbe:	377d                	addiw	a4,a4,-1
    80005bc0:	1702                	slli	a4,a4,0x20
    80005bc2:	9301                	srli	a4,a4,0x20
    80005bc4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005bc8:	fff4c503          	lbu	a0,-1(s1)
    80005bcc:	00000097          	auipc	ra,0x0
    80005bd0:	d60080e7          	jalr	-672(ra) # 8000592c <consputc>
  while(--i >= 0)
    80005bd4:	14fd                	addi	s1,s1,-1
    80005bd6:	ff2499e3          	bne	s1,s2,80005bc8 <printint+0x7c>
}
    80005bda:	70a2                	ld	ra,40(sp)
    80005bdc:	7402                	ld	s0,32(sp)
    80005bde:	64e2                	ld	s1,24(sp)
    80005be0:	6942                	ld	s2,16(sp)
    80005be2:	6145                	addi	sp,sp,48
    80005be4:	8082                	ret
    x = -xx;
    80005be6:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005bea:	4885                	li	a7,1
    x = -xx;
    80005bec:	bf9d                	j	80005b62 <printint+0x16>

0000000080005bee <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005bee:	1101                	addi	sp,sp,-32
    80005bf0:	ec06                	sd	ra,24(sp)
    80005bf2:	e822                	sd	s0,16(sp)
    80005bf4:	e426                	sd	s1,8(sp)
    80005bf6:	1000                	addi	s0,sp,32
    80005bf8:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005bfa:	0001c797          	auipc	a5,0x1c
    80005bfe:	1207ab23          	sw	zero,310(a5) # 80021d30 <pr+0x18>
  printf("panic: ");
    80005c02:	00003517          	auipc	a0,0x3
    80005c06:	c0650513          	addi	a0,a0,-1018 # 80008808 <syscalls+0x3f8>
    80005c0a:	00000097          	auipc	ra,0x0
    80005c0e:	02e080e7          	jalr	46(ra) # 80005c38 <printf>
  printf(s);
    80005c12:	8526                	mv	a0,s1
    80005c14:	00000097          	auipc	ra,0x0
    80005c18:	024080e7          	jalr	36(ra) # 80005c38 <printf>
  printf("\n");
    80005c1c:	00002517          	auipc	a0,0x2
    80005c20:	42c50513          	addi	a0,a0,1068 # 80008048 <etext+0x48>
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	014080e7          	jalr	20(ra) # 80005c38 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c2c:	4785                	li	a5,1
    80005c2e:	00003717          	auipc	a4,0x3
    80005c32:	caf72f23          	sw	a5,-834(a4) # 800088ec <panicked>
  for(;;)
    80005c36:	a001                	j	80005c36 <panic+0x48>

0000000080005c38 <printf>:
{
    80005c38:	7131                	addi	sp,sp,-192
    80005c3a:	fc86                	sd	ra,120(sp)
    80005c3c:	f8a2                	sd	s0,112(sp)
    80005c3e:	f4a6                	sd	s1,104(sp)
    80005c40:	f0ca                	sd	s2,96(sp)
    80005c42:	ecce                	sd	s3,88(sp)
    80005c44:	e8d2                	sd	s4,80(sp)
    80005c46:	e4d6                	sd	s5,72(sp)
    80005c48:	e0da                	sd	s6,64(sp)
    80005c4a:	fc5e                	sd	s7,56(sp)
    80005c4c:	f862                	sd	s8,48(sp)
    80005c4e:	f466                	sd	s9,40(sp)
    80005c50:	f06a                	sd	s10,32(sp)
    80005c52:	ec6e                	sd	s11,24(sp)
    80005c54:	0100                	addi	s0,sp,128
    80005c56:	8a2a                	mv	s4,a0
    80005c58:	e40c                	sd	a1,8(s0)
    80005c5a:	e810                	sd	a2,16(s0)
    80005c5c:	ec14                	sd	a3,24(s0)
    80005c5e:	f018                	sd	a4,32(s0)
    80005c60:	f41c                	sd	a5,40(s0)
    80005c62:	03043823          	sd	a6,48(s0)
    80005c66:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c6a:	0001cd97          	auipc	s11,0x1c
    80005c6e:	0c6dad83          	lw	s11,198(s11) # 80021d30 <pr+0x18>
  if(locking)
    80005c72:	020d9b63          	bnez	s11,80005ca8 <printf+0x70>
  if (fmt == 0)
    80005c76:	040a0263          	beqz	s4,80005cba <printf+0x82>
  va_start(ap, fmt);
    80005c7a:	00840793          	addi	a5,s0,8
    80005c7e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c82:	000a4503          	lbu	a0,0(s4)
    80005c86:	14050f63          	beqz	a0,80005de4 <printf+0x1ac>
    80005c8a:	4981                	li	s3,0
    if(c != '%'){
    80005c8c:	02500a93          	li	s5,37
    switch(c){
    80005c90:	07000b93          	li	s7,112
  consputc('x');
    80005c94:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c96:	00003b17          	auipc	s6,0x3
    80005c9a:	b9ab0b13          	addi	s6,s6,-1126 # 80008830 <digits>
    switch(c){
    80005c9e:	07300c93          	li	s9,115
    80005ca2:	06400c13          	li	s8,100
    80005ca6:	a82d                	j	80005ce0 <printf+0xa8>
    acquire(&pr.lock);
    80005ca8:	0001c517          	auipc	a0,0x1c
    80005cac:	07050513          	addi	a0,a0,112 # 80021d18 <pr>
    80005cb0:	00000097          	auipc	ra,0x0
    80005cb4:	47a080e7          	jalr	1146(ra) # 8000612a <acquire>
    80005cb8:	bf7d                	j	80005c76 <printf+0x3e>
    panic("null fmt");
    80005cba:	00003517          	auipc	a0,0x3
    80005cbe:	b5e50513          	addi	a0,a0,-1186 # 80008818 <syscalls+0x408>
    80005cc2:	00000097          	auipc	ra,0x0
    80005cc6:	f2c080e7          	jalr	-212(ra) # 80005bee <panic>
      consputc(c);
    80005cca:	00000097          	auipc	ra,0x0
    80005cce:	c62080e7          	jalr	-926(ra) # 8000592c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cd2:	2985                	addiw	s3,s3,1
    80005cd4:	013a07b3          	add	a5,s4,s3
    80005cd8:	0007c503          	lbu	a0,0(a5)
    80005cdc:	10050463          	beqz	a0,80005de4 <printf+0x1ac>
    if(c != '%'){
    80005ce0:	ff5515e3          	bne	a0,s5,80005cca <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ce4:	2985                	addiw	s3,s3,1
    80005ce6:	013a07b3          	add	a5,s4,s3
    80005cea:	0007c783          	lbu	a5,0(a5)
    80005cee:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005cf2:	cbed                	beqz	a5,80005de4 <printf+0x1ac>
    switch(c){
    80005cf4:	05778a63          	beq	a5,s7,80005d48 <printf+0x110>
    80005cf8:	02fbf663          	bgeu	s7,a5,80005d24 <printf+0xec>
    80005cfc:	09978863          	beq	a5,s9,80005d8c <printf+0x154>
    80005d00:	07800713          	li	a4,120
    80005d04:	0ce79563          	bne	a5,a4,80005dce <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d08:	f8843783          	ld	a5,-120(s0)
    80005d0c:	00878713          	addi	a4,a5,8
    80005d10:	f8e43423          	sd	a4,-120(s0)
    80005d14:	4605                	li	a2,1
    80005d16:	85ea                	mv	a1,s10
    80005d18:	4388                	lw	a0,0(a5)
    80005d1a:	00000097          	auipc	ra,0x0
    80005d1e:	e32080e7          	jalr	-462(ra) # 80005b4c <printint>
      break;
    80005d22:	bf45                	j	80005cd2 <printf+0x9a>
    switch(c){
    80005d24:	09578f63          	beq	a5,s5,80005dc2 <printf+0x18a>
    80005d28:	0b879363          	bne	a5,s8,80005dce <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d2c:	f8843783          	ld	a5,-120(s0)
    80005d30:	00878713          	addi	a4,a5,8
    80005d34:	f8e43423          	sd	a4,-120(s0)
    80005d38:	4605                	li	a2,1
    80005d3a:	45a9                	li	a1,10
    80005d3c:	4388                	lw	a0,0(a5)
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	e0e080e7          	jalr	-498(ra) # 80005b4c <printint>
      break;
    80005d46:	b771                	j	80005cd2 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d48:	f8843783          	ld	a5,-120(s0)
    80005d4c:	00878713          	addi	a4,a5,8
    80005d50:	f8e43423          	sd	a4,-120(s0)
    80005d54:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d58:	03000513          	li	a0,48
    80005d5c:	00000097          	auipc	ra,0x0
    80005d60:	bd0080e7          	jalr	-1072(ra) # 8000592c <consputc>
  consputc('x');
    80005d64:	07800513          	li	a0,120
    80005d68:	00000097          	auipc	ra,0x0
    80005d6c:	bc4080e7          	jalr	-1084(ra) # 8000592c <consputc>
    80005d70:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d72:	03c95793          	srli	a5,s2,0x3c
    80005d76:	97da                	add	a5,a5,s6
    80005d78:	0007c503          	lbu	a0,0(a5)
    80005d7c:	00000097          	auipc	ra,0x0
    80005d80:	bb0080e7          	jalr	-1104(ra) # 8000592c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d84:	0912                	slli	s2,s2,0x4
    80005d86:	34fd                	addiw	s1,s1,-1
    80005d88:	f4ed                	bnez	s1,80005d72 <printf+0x13a>
    80005d8a:	b7a1                	j	80005cd2 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d8c:	f8843783          	ld	a5,-120(s0)
    80005d90:	00878713          	addi	a4,a5,8
    80005d94:	f8e43423          	sd	a4,-120(s0)
    80005d98:	6384                	ld	s1,0(a5)
    80005d9a:	cc89                	beqz	s1,80005db4 <printf+0x17c>
      for(; *s; s++)
    80005d9c:	0004c503          	lbu	a0,0(s1)
    80005da0:	d90d                	beqz	a0,80005cd2 <printf+0x9a>
        consputc(*s);
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	b8a080e7          	jalr	-1142(ra) # 8000592c <consputc>
      for(; *s; s++)
    80005daa:	0485                	addi	s1,s1,1
    80005dac:	0004c503          	lbu	a0,0(s1)
    80005db0:	f96d                	bnez	a0,80005da2 <printf+0x16a>
    80005db2:	b705                	j	80005cd2 <printf+0x9a>
        s = "(null)";
    80005db4:	00003497          	auipc	s1,0x3
    80005db8:	a5c48493          	addi	s1,s1,-1444 # 80008810 <syscalls+0x400>
      for(; *s; s++)
    80005dbc:	02800513          	li	a0,40
    80005dc0:	b7cd                	j	80005da2 <printf+0x16a>
      consputc('%');
    80005dc2:	8556                	mv	a0,s5
    80005dc4:	00000097          	auipc	ra,0x0
    80005dc8:	b68080e7          	jalr	-1176(ra) # 8000592c <consputc>
      break;
    80005dcc:	b719                	j	80005cd2 <printf+0x9a>
      consputc('%');
    80005dce:	8556                	mv	a0,s5
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	b5c080e7          	jalr	-1188(ra) # 8000592c <consputc>
      consputc(c);
    80005dd8:	8526                	mv	a0,s1
    80005dda:	00000097          	auipc	ra,0x0
    80005dde:	b52080e7          	jalr	-1198(ra) # 8000592c <consputc>
      break;
    80005de2:	bdc5                	j	80005cd2 <printf+0x9a>
  if(locking)
    80005de4:	020d9163          	bnez	s11,80005e06 <printf+0x1ce>
}
    80005de8:	70e6                	ld	ra,120(sp)
    80005dea:	7446                	ld	s0,112(sp)
    80005dec:	74a6                	ld	s1,104(sp)
    80005dee:	7906                	ld	s2,96(sp)
    80005df0:	69e6                	ld	s3,88(sp)
    80005df2:	6a46                	ld	s4,80(sp)
    80005df4:	6aa6                	ld	s5,72(sp)
    80005df6:	6b06                	ld	s6,64(sp)
    80005df8:	7be2                	ld	s7,56(sp)
    80005dfa:	7c42                	ld	s8,48(sp)
    80005dfc:	7ca2                	ld	s9,40(sp)
    80005dfe:	7d02                	ld	s10,32(sp)
    80005e00:	6de2                	ld	s11,24(sp)
    80005e02:	6129                	addi	sp,sp,192
    80005e04:	8082                	ret
    release(&pr.lock);
    80005e06:	0001c517          	auipc	a0,0x1c
    80005e0a:	f1250513          	addi	a0,a0,-238 # 80021d18 <pr>
    80005e0e:	00000097          	auipc	ra,0x0
    80005e12:	3d0080e7          	jalr	976(ra) # 800061de <release>
}
    80005e16:	bfc9                	j	80005de8 <printf+0x1b0>

0000000080005e18 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e18:	1101                	addi	sp,sp,-32
    80005e1a:	ec06                	sd	ra,24(sp)
    80005e1c:	e822                	sd	s0,16(sp)
    80005e1e:	e426                	sd	s1,8(sp)
    80005e20:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e22:	0001c497          	auipc	s1,0x1c
    80005e26:	ef648493          	addi	s1,s1,-266 # 80021d18 <pr>
    80005e2a:	00003597          	auipc	a1,0x3
    80005e2e:	9fe58593          	addi	a1,a1,-1538 # 80008828 <syscalls+0x418>
    80005e32:	8526                	mv	a0,s1
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	266080e7          	jalr	614(ra) # 8000609a <initlock>
  pr.locking = 1;
    80005e3c:	4785                	li	a5,1
    80005e3e:	cc9c                	sw	a5,24(s1)
}
    80005e40:	60e2                	ld	ra,24(sp)
    80005e42:	6442                	ld	s0,16(sp)
    80005e44:	64a2                	ld	s1,8(sp)
    80005e46:	6105                	addi	sp,sp,32
    80005e48:	8082                	ret

0000000080005e4a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005e4a:	1141                	addi	sp,sp,-16
    80005e4c:	e406                	sd	ra,8(sp)
    80005e4e:	e022                	sd	s0,0(sp)
    80005e50:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e52:	100007b7          	lui	a5,0x10000
    80005e56:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e5a:	f8000713          	li	a4,-128
    80005e5e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e62:	470d                	li	a4,3
    80005e64:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e68:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e6c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e70:	469d                	li	a3,7
    80005e72:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e76:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e7a:	00003597          	auipc	a1,0x3
    80005e7e:	9ce58593          	addi	a1,a1,-1586 # 80008848 <digits+0x18>
    80005e82:	0001c517          	auipc	a0,0x1c
    80005e86:	eb650513          	addi	a0,a0,-330 # 80021d38 <uart_tx_lock>
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	210080e7          	jalr	528(ra) # 8000609a <initlock>
}
    80005e92:	60a2                	ld	ra,8(sp)
    80005e94:	6402                	ld	s0,0(sp)
    80005e96:	0141                	addi	sp,sp,16
    80005e98:	8082                	ret

0000000080005e9a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e9a:	1101                	addi	sp,sp,-32
    80005e9c:	ec06                	sd	ra,24(sp)
    80005e9e:	e822                	sd	s0,16(sp)
    80005ea0:	e426                	sd	s1,8(sp)
    80005ea2:	1000                	addi	s0,sp,32
    80005ea4:	84aa                	mv	s1,a0
  push_off();
    80005ea6:	00000097          	auipc	ra,0x0
    80005eaa:	238080e7          	jalr	568(ra) # 800060de <push_off>

  if(panicked){
    80005eae:	00003797          	auipc	a5,0x3
    80005eb2:	a3e7a783          	lw	a5,-1474(a5) # 800088ec <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005eb6:	10000737          	lui	a4,0x10000
  if(panicked){
    80005eba:	c391                	beqz	a5,80005ebe <uartputc_sync+0x24>
    for(;;)
    80005ebc:	a001                	j	80005ebc <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ebe:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005ec2:	0207f793          	andi	a5,a5,32
    80005ec6:	dfe5                	beqz	a5,80005ebe <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005ec8:	0ff4f513          	andi	a0,s1,255
    80005ecc:	100007b7          	lui	a5,0x10000
    80005ed0:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005ed4:	00000097          	auipc	ra,0x0
    80005ed8:	2aa080e7          	jalr	682(ra) # 8000617e <pop_off>
}
    80005edc:	60e2                	ld	ra,24(sp)
    80005ede:	6442                	ld	s0,16(sp)
    80005ee0:	64a2                	ld	s1,8(sp)
    80005ee2:	6105                	addi	sp,sp,32
    80005ee4:	8082                	ret

0000000080005ee6 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005ee6:	00003797          	auipc	a5,0x3
    80005eea:	a0a7b783          	ld	a5,-1526(a5) # 800088f0 <uart_tx_r>
    80005eee:	00003717          	auipc	a4,0x3
    80005ef2:	a0a73703          	ld	a4,-1526(a4) # 800088f8 <uart_tx_w>
    80005ef6:	06f70a63          	beq	a4,a5,80005f6a <uartstart+0x84>
{
    80005efa:	7139                	addi	sp,sp,-64
    80005efc:	fc06                	sd	ra,56(sp)
    80005efe:	f822                	sd	s0,48(sp)
    80005f00:	f426                	sd	s1,40(sp)
    80005f02:	f04a                	sd	s2,32(sp)
    80005f04:	ec4e                	sd	s3,24(sp)
    80005f06:	e852                	sd	s4,16(sp)
    80005f08:	e456                	sd	s5,8(sp)
    80005f0a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f0c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f10:	0001ca17          	auipc	s4,0x1c
    80005f14:	e28a0a13          	addi	s4,s4,-472 # 80021d38 <uart_tx_lock>
    uart_tx_r += 1;
    80005f18:	00003497          	auipc	s1,0x3
    80005f1c:	9d848493          	addi	s1,s1,-1576 # 800088f0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f20:	00003997          	auipc	s3,0x3
    80005f24:	9d898993          	addi	s3,s3,-1576 # 800088f8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f28:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f2c:	02077713          	andi	a4,a4,32
    80005f30:	c705                	beqz	a4,80005f58 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f32:	01f7f713          	andi	a4,a5,31
    80005f36:	9752                	add	a4,a4,s4
    80005f38:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005f3c:	0785                	addi	a5,a5,1
    80005f3e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f40:	8526                	mv	a0,s1
    80005f42:	ffffb097          	auipc	ra,0xffffb
    80005f46:	678080e7          	jalr	1656(ra) # 800015ba <wakeup>
    
    WriteReg(THR, c);
    80005f4a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005f4e:	609c                	ld	a5,0(s1)
    80005f50:	0009b703          	ld	a4,0(s3)
    80005f54:	fcf71ae3          	bne	a4,a5,80005f28 <uartstart+0x42>
  }
}
    80005f58:	70e2                	ld	ra,56(sp)
    80005f5a:	7442                	ld	s0,48(sp)
    80005f5c:	74a2                	ld	s1,40(sp)
    80005f5e:	7902                	ld	s2,32(sp)
    80005f60:	69e2                	ld	s3,24(sp)
    80005f62:	6a42                	ld	s4,16(sp)
    80005f64:	6aa2                	ld	s5,8(sp)
    80005f66:	6121                	addi	sp,sp,64
    80005f68:	8082                	ret
    80005f6a:	8082                	ret

0000000080005f6c <uartputc>:
{
    80005f6c:	7179                	addi	sp,sp,-48
    80005f6e:	f406                	sd	ra,40(sp)
    80005f70:	f022                	sd	s0,32(sp)
    80005f72:	ec26                	sd	s1,24(sp)
    80005f74:	e84a                	sd	s2,16(sp)
    80005f76:	e44e                	sd	s3,8(sp)
    80005f78:	e052                	sd	s4,0(sp)
    80005f7a:	1800                	addi	s0,sp,48
    80005f7c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005f7e:	0001c517          	auipc	a0,0x1c
    80005f82:	dba50513          	addi	a0,a0,-582 # 80021d38 <uart_tx_lock>
    80005f86:	00000097          	auipc	ra,0x0
    80005f8a:	1a4080e7          	jalr	420(ra) # 8000612a <acquire>
  if(panicked){
    80005f8e:	00003797          	auipc	a5,0x3
    80005f92:	95e7a783          	lw	a5,-1698(a5) # 800088ec <panicked>
    80005f96:	e7c9                	bnez	a5,80006020 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f98:	00003717          	auipc	a4,0x3
    80005f9c:	96073703          	ld	a4,-1696(a4) # 800088f8 <uart_tx_w>
    80005fa0:	00003797          	auipc	a5,0x3
    80005fa4:	9507b783          	ld	a5,-1712(a5) # 800088f0 <uart_tx_r>
    80005fa8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005fac:	0001c997          	auipc	s3,0x1c
    80005fb0:	d8c98993          	addi	s3,s3,-628 # 80021d38 <uart_tx_lock>
    80005fb4:	00003497          	auipc	s1,0x3
    80005fb8:	93c48493          	addi	s1,s1,-1732 # 800088f0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fbc:	00003917          	auipc	s2,0x3
    80005fc0:	93c90913          	addi	s2,s2,-1732 # 800088f8 <uart_tx_w>
    80005fc4:	00e79f63          	bne	a5,a4,80005fe2 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005fc8:	85ce                	mv	a1,s3
    80005fca:	8526                	mv	a0,s1
    80005fcc:	ffffb097          	auipc	ra,0xffffb
    80005fd0:	58a080e7          	jalr	1418(ra) # 80001556 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fd4:	00093703          	ld	a4,0(s2)
    80005fd8:	609c                	ld	a5,0(s1)
    80005fda:	02078793          	addi	a5,a5,32
    80005fde:	fee785e3          	beq	a5,a4,80005fc8 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005fe2:	0001c497          	auipc	s1,0x1c
    80005fe6:	d5648493          	addi	s1,s1,-682 # 80021d38 <uart_tx_lock>
    80005fea:	01f77793          	andi	a5,a4,31
    80005fee:	97a6                	add	a5,a5,s1
    80005ff0:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005ff4:	0705                	addi	a4,a4,1
    80005ff6:	00003797          	auipc	a5,0x3
    80005ffa:	90e7b123          	sd	a4,-1790(a5) # 800088f8 <uart_tx_w>
  uartstart();
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	ee8080e7          	jalr	-280(ra) # 80005ee6 <uartstart>
  release(&uart_tx_lock);
    80006006:	8526                	mv	a0,s1
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	1d6080e7          	jalr	470(ra) # 800061de <release>
}
    80006010:	70a2                	ld	ra,40(sp)
    80006012:	7402                	ld	s0,32(sp)
    80006014:	64e2                	ld	s1,24(sp)
    80006016:	6942                	ld	s2,16(sp)
    80006018:	69a2                	ld	s3,8(sp)
    8000601a:	6a02                	ld	s4,0(sp)
    8000601c:	6145                	addi	sp,sp,48
    8000601e:	8082                	ret
    for(;;)
    80006020:	a001                	j	80006020 <uartputc+0xb4>

0000000080006022 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006022:	1141                	addi	sp,sp,-16
    80006024:	e422                	sd	s0,8(sp)
    80006026:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006028:	100007b7          	lui	a5,0x10000
    8000602c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006030:	8b85                	andi	a5,a5,1
    80006032:	cb91                	beqz	a5,80006046 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006034:	100007b7          	lui	a5,0x10000
    80006038:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000603c:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006040:	6422                	ld	s0,8(sp)
    80006042:	0141                	addi	sp,sp,16
    80006044:	8082                	ret
    return -1;
    80006046:	557d                	li	a0,-1
    80006048:	bfe5                	j	80006040 <uartgetc+0x1e>

000000008000604a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000604a:	1101                	addi	sp,sp,-32
    8000604c:	ec06                	sd	ra,24(sp)
    8000604e:	e822                	sd	s0,16(sp)
    80006050:	e426                	sd	s1,8(sp)
    80006052:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006054:	54fd                	li	s1,-1
    80006056:	a029                	j	80006060 <uartintr+0x16>
      break;
    consoleintr(c);
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	916080e7          	jalr	-1770(ra) # 8000596e <consoleintr>
    int c = uartgetc();
    80006060:	00000097          	auipc	ra,0x0
    80006064:	fc2080e7          	jalr	-62(ra) # 80006022 <uartgetc>
    if(c == -1)
    80006068:	fe9518e3          	bne	a0,s1,80006058 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000606c:	0001c497          	auipc	s1,0x1c
    80006070:	ccc48493          	addi	s1,s1,-820 # 80021d38 <uart_tx_lock>
    80006074:	8526                	mv	a0,s1
    80006076:	00000097          	auipc	ra,0x0
    8000607a:	0b4080e7          	jalr	180(ra) # 8000612a <acquire>
  uartstart();
    8000607e:	00000097          	auipc	ra,0x0
    80006082:	e68080e7          	jalr	-408(ra) # 80005ee6 <uartstart>
  release(&uart_tx_lock);
    80006086:	8526                	mv	a0,s1
    80006088:	00000097          	auipc	ra,0x0
    8000608c:	156080e7          	jalr	342(ra) # 800061de <release>
}
    80006090:	60e2                	ld	ra,24(sp)
    80006092:	6442                	ld	s0,16(sp)
    80006094:	64a2                	ld	s1,8(sp)
    80006096:	6105                	addi	sp,sp,32
    80006098:	8082                	ret

000000008000609a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000609a:	1141                	addi	sp,sp,-16
    8000609c:	e422                	sd	s0,8(sp)
    8000609e:	0800                	addi	s0,sp,16
  lk->name = name;
    800060a0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060a2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060a6:	00053823          	sd	zero,16(a0)
}
    800060aa:	6422                	ld	s0,8(sp)
    800060ac:	0141                	addi	sp,sp,16
    800060ae:	8082                	ret

00000000800060b0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800060b0:	411c                	lw	a5,0(a0)
    800060b2:	e399                	bnez	a5,800060b8 <holding+0x8>
    800060b4:	4501                	li	a0,0
  return r;
}
    800060b6:	8082                	ret
{
    800060b8:	1101                	addi	sp,sp,-32
    800060ba:	ec06                	sd	ra,24(sp)
    800060bc:	e822                	sd	s0,16(sp)
    800060be:	e426                	sd	s1,8(sp)
    800060c0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800060c2:	6904                	ld	s1,16(a0)
    800060c4:	ffffb097          	auipc	ra,0xffffb
    800060c8:	dca080e7          	jalr	-566(ra) # 80000e8e <mycpu>
    800060cc:	40a48533          	sub	a0,s1,a0
    800060d0:	00153513          	seqz	a0,a0
}
    800060d4:	60e2                	ld	ra,24(sp)
    800060d6:	6442                	ld	s0,16(sp)
    800060d8:	64a2                	ld	s1,8(sp)
    800060da:	6105                	addi	sp,sp,32
    800060dc:	8082                	ret

00000000800060de <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800060de:	1101                	addi	sp,sp,-32
    800060e0:	ec06                	sd	ra,24(sp)
    800060e2:	e822                	sd	s0,16(sp)
    800060e4:	e426                	sd	s1,8(sp)
    800060e6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060e8:	100024f3          	csrr	s1,sstatus
    800060ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800060f0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800060f2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800060f6:	ffffb097          	auipc	ra,0xffffb
    800060fa:	d98080e7          	jalr	-616(ra) # 80000e8e <mycpu>
    800060fe:	5d3c                	lw	a5,120(a0)
    80006100:	cf89                	beqz	a5,8000611a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006102:	ffffb097          	auipc	ra,0xffffb
    80006106:	d8c080e7          	jalr	-628(ra) # 80000e8e <mycpu>
    8000610a:	5d3c                	lw	a5,120(a0)
    8000610c:	2785                	addiw	a5,a5,1
    8000610e:	dd3c                	sw	a5,120(a0)
}
    80006110:	60e2                	ld	ra,24(sp)
    80006112:	6442                	ld	s0,16(sp)
    80006114:	64a2                	ld	s1,8(sp)
    80006116:	6105                	addi	sp,sp,32
    80006118:	8082                	ret
    mycpu()->intena = old;
    8000611a:	ffffb097          	auipc	ra,0xffffb
    8000611e:	d74080e7          	jalr	-652(ra) # 80000e8e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006122:	8085                	srli	s1,s1,0x1
    80006124:	8885                	andi	s1,s1,1
    80006126:	dd64                	sw	s1,124(a0)
    80006128:	bfe9                	j	80006102 <push_off+0x24>

000000008000612a <acquire>:
{
    8000612a:	1101                	addi	sp,sp,-32
    8000612c:	ec06                	sd	ra,24(sp)
    8000612e:	e822                	sd	s0,16(sp)
    80006130:	e426                	sd	s1,8(sp)
    80006132:	1000                	addi	s0,sp,32
    80006134:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006136:	00000097          	auipc	ra,0x0
    8000613a:	fa8080e7          	jalr	-88(ra) # 800060de <push_off>
  if(holding(lk))
    8000613e:	8526                	mv	a0,s1
    80006140:	00000097          	auipc	ra,0x0
    80006144:	f70080e7          	jalr	-144(ra) # 800060b0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006148:	4705                	li	a4,1
  if(holding(lk))
    8000614a:	e115                	bnez	a0,8000616e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000614c:	87ba                	mv	a5,a4
    8000614e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006152:	2781                	sext.w	a5,a5
    80006154:	ffe5                	bnez	a5,8000614c <acquire+0x22>
  __sync_synchronize();
    80006156:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000615a:	ffffb097          	auipc	ra,0xffffb
    8000615e:	d34080e7          	jalr	-716(ra) # 80000e8e <mycpu>
    80006162:	e888                	sd	a0,16(s1)
}
    80006164:	60e2                	ld	ra,24(sp)
    80006166:	6442                	ld	s0,16(sp)
    80006168:	64a2                	ld	s1,8(sp)
    8000616a:	6105                	addi	sp,sp,32
    8000616c:	8082                	ret
    panic("acquire");
    8000616e:	00002517          	auipc	a0,0x2
    80006172:	6e250513          	addi	a0,a0,1762 # 80008850 <digits+0x20>
    80006176:	00000097          	auipc	ra,0x0
    8000617a:	a78080e7          	jalr	-1416(ra) # 80005bee <panic>

000000008000617e <pop_off>:

void
pop_off(void)
{
    8000617e:	1141                	addi	sp,sp,-16
    80006180:	e406                	sd	ra,8(sp)
    80006182:	e022                	sd	s0,0(sp)
    80006184:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006186:	ffffb097          	auipc	ra,0xffffb
    8000618a:	d08080e7          	jalr	-760(ra) # 80000e8e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000618e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006192:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006194:	e78d                	bnez	a5,800061be <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006196:	5d3c                	lw	a5,120(a0)
    80006198:	02f05b63          	blez	a5,800061ce <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000619c:	37fd                	addiw	a5,a5,-1
    8000619e:	0007871b          	sext.w	a4,a5
    800061a2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061a4:	eb09                	bnez	a4,800061b6 <pop_off+0x38>
    800061a6:	5d7c                	lw	a5,124(a0)
    800061a8:	c799                	beqz	a5,800061b6 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061aa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800061ae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061b2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800061b6:	60a2                	ld	ra,8(sp)
    800061b8:	6402                	ld	s0,0(sp)
    800061ba:	0141                	addi	sp,sp,16
    800061bc:	8082                	ret
    panic("pop_off - interruptible");
    800061be:	00002517          	auipc	a0,0x2
    800061c2:	69a50513          	addi	a0,a0,1690 # 80008858 <digits+0x28>
    800061c6:	00000097          	auipc	ra,0x0
    800061ca:	a28080e7          	jalr	-1496(ra) # 80005bee <panic>
    panic("pop_off");
    800061ce:	00002517          	auipc	a0,0x2
    800061d2:	6a250513          	addi	a0,a0,1698 # 80008870 <digits+0x40>
    800061d6:	00000097          	auipc	ra,0x0
    800061da:	a18080e7          	jalr	-1512(ra) # 80005bee <panic>

00000000800061de <release>:
{
    800061de:	1101                	addi	sp,sp,-32
    800061e0:	ec06                	sd	ra,24(sp)
    800061e2:	e822                	sd	s0,16(sp)
    800061e4:	e426                	sd	s1,8(sp)
    800061e6:	1000                	addi	s0,sp,32
    800061e8:	84aa                	mv	s1,a0
  if(!holding(lk))
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	ec6080e7          	jalr	-314(ra) # 800060b0 <holding>
    800061f2:	c115                	beqz	a0,80006216 <release+0x38>
  lk->cpu = 0;
    800061f4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800061f8:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800061fc:	0f50000f          	fence	iorw,ow
    80006200:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006204:	00000097          	auipc	ra,0x0
    80006208:	f7a080e7          	jalr	-134(ra) # 8000617e <pop_off>
}
    8000620c:	60e2                	ld	ra,24(sp)
    8000620e:	6442                	ld	s0,16(sp)
    80006210:	64a2                	ld	s1,8(sp)
    80006212:	6105                	addi	sp,sp,32
    80006214:	8082                	ret
    panic("release");
    80006216:	00002517          	auipc	a0,0x2
    8000621a:	66250513          	addi	a0,a0,1634 # 80008878 <digits+0x48>
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	9d0080e7          	jalr	-1584(ra) # 80005bee <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
